//
//  PrayerWidgetViewModel.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import Combine
import CoreLocation

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
class PrayerWidgetViewModel: ObservableObject {
    @Published var prayerTimes: UmmahPrayerTimesEntity?
    @Published var currentStatus: UmmahPrayerStatusEntity?
    @Published var locationName: String = "Jakarta"
    @Published var isLoading: Bool = false
    @Published var dateString: String = ""
    @Published var islamicInfo: UmmahPrayerIslamicInfoEntity?
    @Published var countdownString: String = ""
    @Published var nextPrayerName: String = ""
    @Published var activePrayerName: String?
    @Published var madhab: String = ""
    
    private let getPrayerTimesUseCase: GetPrayerTimesUseCase
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    init(getPrayerTimesUseCase: GetPrayerTimesUseCase = DIContainer.shared.getPrayerTimesUseCase) {
        self.getPrayerTimesUseCase = getPrayerTimesUseCase
        
        setupLocationObserver()
        updateDateString()
        startTimer()
    }
    
    private func startTimer() {
        // Run every second for smooth countdown
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        guard let times = prayerTimes else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let datePart = DateFormatter()
        datePart.dateFormat = "yyyy-MM-dd"
        let today = datePart.string(from: Date())
        
        let order = ["imsak", "fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha"]
        
        // 1. Find the CURRENT active prayer (Last one that passed)
        self.activePrayerName = nil
        for name in order.reversed() {
            let timeStr = (name == "imsak" ? times.imsak : name == "fajr" ? times.fajr : name == "sunrise" ? times.sunrise : name == "dhuhr" ? times.dhuhr : name == "asr" ? times.asr : name == "maghrib" ? times.maghrib : times.isha)
            
            if let pDate = formatter.date(from: "\(today) \(timeStr)") {
                if Date() >= pDate {
                    self.activePrayerName = name
                    break
                }
            }
        }
        
        // 2. Find the actual next prayer dynamically
        var nextPrayer: (name: String, date: Date)?
        for (name, timeStr) in [
            ("imsak", times.imsak), ("fajr", times.fajr), ("sunrise", times.sunrise),
            ("dhuhr", times.dhuhr), ("asr", times.asr), ("maghrib", times.maghrib), ("isha", times.isha)
        ] {
            if let pDate = formatter.date(from: "\(today) \(timeStr)") {
                if pDate > Date() {
                    nextPrayer = (name, pDate)
                    break 
                }
            }
        }
        
        // 3. Wrap to tomorrow if none found
        if nextPrayer == nil {
            if let firstTime = [times.imsak, times.fajr, times.sunrise, times.dhuhr, times.asr, times.maghrib, times.isha].first,
               let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()),
               let pDate = formatter.date(from: "\(datePart.string(from: tomorrow)) \(firstTime)") {
                nextPrayer = ("imsak", pDate)
            }
        }
        
        guard let next = nextPrayer else { return }
        
        // Update UI properties
        self.nextPrayerName = next.name
        
        // 4. Calculate Diff
        let diff = Int(next.date.timeIntervalSince(Date()))
        
        if diff <= 0 {
            self.countdownString = "00:00"
            if diff > -2 {
                fetchPrayerTimes(for: locationManager.location ?? CLLocation(latitude: -6.2, longitude: 106.8))
            }
        } else {
            let hours = diff / 3600
            let minutes = (diff % 3600) / 60
            let seconds = diff % 60
            
            if hours > 0 {
                self.countdownString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                self.countdownString = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
    
    private func updateDateString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        self.dateString = formatter.string(from: Date())
    }
    
    private func setupLocationObserver() {
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.fetchPrayerTimes(for: location)
            }
            .store(in: &cancellables)
        
        locationManager.$cityName
            .sink { [weak self] name in
                self?.locationName = name
            }
            .store(in: &cancellables)
            
        locationManager.requestAuthorization()
    }
    
    func fetchPrayerTimes(for location: CLLocation) {
        isLoading = true
        
        getPrayerTimesUseCase.execute(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude,
            method: nil // Default
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                print("❌ Failed to fetch prayer times: \(error)")
            }
        } receiveValue: { [weak self] response in
            self?.prayerTimes = response.data.prayerTimes.toDomain()
            self?.currentStatus = response.data.currentStatus?.toDomain()
            self?.islamicInfo = response.data.islamicInfo?.toDomain()
            self?.madhab = response.data.madhab
            self?.updateCountdown()
        }
        .store(in: &cancellables)
    }
}
