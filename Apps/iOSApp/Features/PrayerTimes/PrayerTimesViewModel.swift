import SwiftUI
import Observation
import Combine
import CoreLocation

public enum PrayerReminderType: String, Codable, CaseIterable {
    case adhan
    case alarm
    case silent
    
    var icon: String {
        switch self {
        case .adhan: return "building.2.fill"
        case .alarm: return "alarm.fill"
        case .silent: return "bell.slash.fill"
        }
    }
}

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
@Observable
public final class PrayerTimesViewModel {
    // MARK: - Properties
    private let repository: UmmahPrayerRepository
    private let locationManager = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    public var isLoading: Bool = false
    public var errorMessage: String?
    
    // Data
    public var prayerResponse: PrayerTimesResponse?
    public var monthlyTimetable: MonthlyTimetableResponse?
    public var ramadanTimetable: RamadanTimetableResponse?
    public var methods: [String: CalculationMethodModel] = [:]
    
    // Settings
    public var selectedMethod: String = "MuslimWorldLeague"
    public var selectedMadhab: String = "Shafi"
    public var reminders: [String: PrayerReminderType] = [:]
    
    // UI State
    public var selectedMonthlyDate: String?
    public var countdownString: String = ""
    public var nextPrayerName: String = ""
    public var activePrayerName: String?
    private var timer: Timer?
    
    public var isRamadan: Bool {
        guard let response = ramadanTimetable else { return false }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        // Tab should show if today is within Ramadan range
        return today >= response.ramadanStart && today <= response.ramadanEnd
    }
    
    // MARK: - Initialization
    public init(repository: UmmahPrayerRepository = DIContainer.shared.ummahPrayerRepository) {
        self.repository = repository
        loadSettings()
        setupLocationTracking()
        NotificationManager.shared.requestAuthorization()
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateLocalCountdown()
        }
    }
    
    private func updateLocalCountdown() {
        guard let times = prayerResponse?.prayerTimes.toMap() else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let datePart = DateFormatter()
        datePart.dateFormat = "yyyy-MM-dd"
        let today = datePart.string(from: Date())
        
        let order = ["imsak", "fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha"]
        
        // 1. Find the CURRENT active prayer (Last one that passed)
        self.activePrayerName = nil
        for name in order.reversed() {
            if let timeStr = times[name],
               let pDate = formatter.date(from: "\(today) \(timeStr)") {
                if Date() >= pDate {
                    self.activePrayerName = name
                    break
                }
            }
        }
        
        // 2. Find the actual next prayer
        var nextPrayer: (name: String, date: Date)?
        for name in order {
            if let timeStr = times[name], 
               let pDate = formatter.date(from: "\(today) \(timeStr)") {
                if pDate > Date() {
                    nextPrayer = (name, pDate)
                    break 
                }
            }
        }
        
        // Handle wrap to tomorrow
        if nextPrayer == nil {
            if let firstKey = order.first,
               let firstTime = times[firstKey],
               let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()),
               let pDate = formatter.date(from: "\(datePart.string(from: tomorrow)) \(firstTime)") {
                nextPrayer = (firstKey, pDate)
            }
        }
        
        guard let next = nextPrayer else { return }
        self.nextPrayerName = next.name
        
        // 3. Calculate Diff
        let diff = Int(next.date.timeIntervalSince(Date()))
        
        if diff <= 0 {
            self.countdownString = "00:00"
            if diff > -2 { refreshTimes() }
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
    
    // MARK: - Public Logic
    public func fetchAllData() {
        fetchMethods()
        refreshTimes()
        fetchRamadanTimes()
    }
    
    public func fetchRamadanTimes() {
        guard let location = LocationManager.shared.location else { return }
        let year = Calendar.current.component(.year, from: Date())
        
        repository.getRamadanTimetable(year: year, lat: location.coordinate.latitude, lng: location.coordinate.longitude, method: selectedMethod, madhab: selectedMadhab, timezone: nil)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.ramadanTimetable = response.data
            }
            .store(in: &cancellables)
    }
    
    public func refreshTimes() {
        guard let location = LocationManager.shared.location else { return }
        fetchDailyTimes(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        fetchMonthlyTimes(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
    }
    
    public func updateMethod(_ method: String) {
        selectedMethod = method
        saveSettings()
        refreshTimes()
    }
    
    public func updateMadhab(_ madhab: String) {
        selectedMadhab = madhab
        saveSettings()
        refreshTimes()
    }
    
    public func toggleReminder(for prayer: String, on date: String? = nil) {
        // Prevent toggling past dates
        if let dateStr = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let d = formatter.date(from: dateStr) {
                let calendar = Calendar.current
                let startOfToday = calendar.startOfDay(for: Date())
                if d < startOfToday { return }
            }
        }
        
        let key = reminderKey(for: prayer, on: date)
        let current = getReminderType(for: prayer, on: date)
        let all = PrayerReminderType.allCases
        
        if let index = all.firstIndex(of: current) {
            let nextIndex = (index + 1) % all.count
            reminders[key] = all[nextIndex]
            saveSettings()
            scheduleNotifications()
        }
    }
    
    public func getReminderType(for prayer: String, on date: String? = nil) -> PrayerReminderType {
        let prayerKey = prayer.lowercased()
        if let date = date, let specific = reminders["\(date)_\(prayerKey)"] {
            return specific
        }
        return reminders[prayerKey] ?? defaultReminder(for: prayer)
    }
    
    private func reminderKey(for prayer: String, on date: String?) -> String {
        let prayerKey = prayer.lowercased()
        if let date = date {
            return "\(date)_\(prayerKey)"
        }
        return prayerKey
    }
    
    // MARK: - Private Logic
    private func fetchMethods() {
        repository.getMethods()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.methods = response.data.methods
            }
            .store(in: &cancellables)
    }
    private func fetchDailyTimes(lat: Double, lng: Double) {
        isLoading = true
        repository.getPrayerTimes(lat: lat, lng: lng, date: nil, method: selectedMethod, madhab: selectedMadhab, timezone: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.prayerResponse = response.data
                self?.scheduleNotifications()
            }
            .store(in: &cancellables)
    }
    
    private func scheduleNotifications() {
        NotificationManager.shared.clearAllNotifications()
        
        // 1. Schedule Today
        if let todayTimes = prayerResponse?.prayerTimes.toMap() {
            NotificationManager.shared.schedulePrayerNotifications(for: Date(), times: todayTimes, reminders: reminders)
        }
        
        // 2. Schedule Future (Next 7 days from monthly table)
        if let days = monthlyTimetable?.days {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayStr = formatter.string(from: Date())
            
            for day in days {
                if day.date == todayStr { continue }
                if let d = formatter.date(from: day.date) {
                    let calendar = Calendar.current
                    let startOfToday = calendar.startOfDay(for: Date())
                    let diff = calendar.dateComponents([.day], from: startOfToday, to: d).day ?? 0
                    if diff > 0 && diff <= 7 {
                        NotificationManager.shared.schedulePrayerNotifications(for: d, times: day.prayerTimes.toMap(), reminders: reminders)
                    }
                }
            }
        }
    }
    
    private func fetchMonthlyTimes(lat: Double, lng: Double) {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        repository.getMonthlyTimetable(lat: lat, lng: lng, month: month, year: year, method: selectedMethod, madhab: selectedMadhab, timezone: nil)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.monthlyTimetable = response.data
                if self?.selectedMonthlyDate == nil {
                    let today = DateFormatter()
                    today.dateFormat = "yyyy-MM-dd"
                    self?.selectedMonthlyDate = today.string(from: Date())
                }
                self?.scheduleNotifications()
            }
            .store(in: &cancellables)
    }
    
    private func setupLocationTracking() {
        LocationManager.shared.$location
            .compactMap { $0 }
            .debounce(for: DispatchQueue.SchedulerTimeType.Stride.seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshTimes()
            }
            .store(in: &cancellables)
    }
    
    private func defaultReminder(for prayer: String) -> PrayerReminderType {
        let lower = prayer.lowercased()
        if lower == "imsak" || lower == "sunrise" {
            return .alarm
        }
        return .adhan
    }
    
    // MARK: - Persistence
    private func saveSettings() {
        UserDefaults.standard.set(selectedMethod, forKey: "HIRA_PRAYER_METHOD")
        UserDefaults.standard.set(selectedMadhab, forKey: "HIRA_PRAYER_MADHAB")
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_PRAYER_REMINDERS")
        }
    }
    
    private func loadSettings() {
        if let method = UserDefaults.standard.string(forKey: "HIRA_PRAYER_METHOD") {
            selectedMethod = method
        }
        if let madhab = UserDefaults.standard.string(forKey: "HIRA_PRAYER_MADHAB") {
            selectedMadhab = madhab
        }
        if let data = UserDefaults.standard.data(forKey: "HIRA_PRAYER_REMINDERS"),
           let decoded = try? JSONDecoder().decode([String: PrayerReminderType].self, from: data) {
            reminders = decoded
        }
    }
}
