import Foundation
import Observation
import Combine
import SwiftUI

@Observable
public final class CalendarViewModel {
    // MARK: - State
    public var today: UmmahDateConversion?
    public var currentMonthDays: [HijriCalendarDay] = []
    public var events: [UmmahIslamicEvent] = []
    public var monthsInfo: [UmmahIslamicMonth] = []
    
    public var selectedMonth: Int = 1
    public var selectedYear: Int = 1447
    public var isLoading: Bool = false
    
    // MARK: - Dependencies
    private let repository: UmmahDateRepository
    private var cancellables = Set<AnyCancellable>()
    private var hasInitialized = false

    
    public init(repository: UmmahDateRepository = DIContainer.shared.ummahDateRepository) {
        self.repository = repository
    }

    public func loadData() {
        guard !hasInitialized else { return }
        hasInitialized = true
        
        fetchToday()
        fetchMonthsInfo()
        fetchEvents()
    }

    
    private func fetchToday() {
        isLoading = true
        repository.getTodayHijri()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in 
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.today = response.data.toDomain()
                self.selectedMonth = self.today?.hijri.month ?? 1
                self.selectedYear = self.today?.hijri.year ?? 1447
                self.generateMonthGrid()
            }
            .store(in: &cancellables)
    }
    
    public func fetchMonthsInfo() {
        repository.getIslamicMonths()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.monthsInfo = response.data.months.map { $0.toDomain() }
            }
            .store(in: &cancellables)
    }
    
    public func fetchEvents() {
        repository.getIslamicEvents(year: selectedYear)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.events = response.data.events.map { $0.toDomain() }
            }
            .store(in: &cancellables)
    }
    
    public func nextMonth() {
        if selectedMonth == 12 {
            selectedMonth = 1
            selectedYear += 1
        } else {
            selectedMonth += 1
        }
        generateMonthGrid()
    }
    
    public func prevMonth() {
        if selectedMonth == 1 {
            selectedMonth = 12
            selectedYear -= 1
        } else {
            selectedMonth -= 1
        }
        generateMonthGrid()
    }
    
    public func jumpTo(month: Int, year: Int) {
        self.selectedMonth = month
        self.selectedYear = year
        generateMonthGrid()
    }
    
    public func generateMonthGrid() {
        isLoading = true
        // Fetch the gregorian date for the 1st of the Hijri month to find the weekday
        repository.convertHijriToGregorian(year: selectedYear, month: selectedMonth, day: 1)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in 
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                let startGregorian = response.data.toDomain().gregorian
                self.buildGrid(startingOn: startGregorian)
            }
            .store(in: &cancellables)
    }
    
    private func buildGrid(startingOn gregorian: GregorianDate) {
        var days: [HijriCalendarDay] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = formatter.date(from: gregorian.date) else { return }
        
        // Find weekday of the 1st
        let calendar = Calendar.current
        let firstWeekday = calendar.component(.weekday, from: startDate)
        
        // Add padding for previous month days (empty cells or actual days)
        // 1 = Sunday, 2 = Monday, ...
        // If 1st is Monday (2), we need 1 empty cell (Sunday)
        for _ in 1..<firstWeekday {
            days.append(HijriCalendarDay(hijriDay: 0, hijriMonth: 0, hijriYear: 0, gregorianDate: nil, isToday: false, isCurrentMonth: false, event: nil))
        }
        
        // Add days of the month (assume 30 for now, we'll validate if needed)
        // In a real app, we might need a 30th-day-check API call
        for i in 1...30 {
            let gDate = calendar.date(byAdding: .day, value: i - 1, to: startDate)
            let isToday = calendar.isDateInToday(gDate ?? Date())
            
            // Check for events
            let event = events.first(where: { $0.month == selectedMonth && $0.day == i })?.title
            
            days.append(HijriCalendarDay(
                hijriDay: i,
                hijriMonth: selectedMonth,
                hijriYear: selectedYear,
                gregorianDate: gDate,
                isToday: isToday,
                isCurrentMonth: true,
                event: event
            ))
        }
        
        self.currentMonthDays = days
    }
    
    public var currentMonthName: String {
        monthsInfo.first(where: { $0.id == selectedMonth })?.name ?? "..."
    }
    
    public var currentMonthNameArabic: String {
        monthsInfo.first(where: { $0.id == selectedMonth })?.nameArabic ?? "..."
    }
}

