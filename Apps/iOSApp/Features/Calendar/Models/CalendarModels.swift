//
//  CalendarModels.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import Foundation

public struct HijriCalendarDay: Identifiable, Equatable {
    public let id = UUID()
    public let hijriDay: Int
    public let hijriMonth: Int
    public let hijriYear: Int
    public let gregorianDate: Date?
    public let isToday: Bool
    public let isCurrentMonth: Bool
    public let event: String?
}

public struct HijriMonthDisplay: Identifiable, Equatable {
    public let id: Int // Month number 1-12
    public let name: String
    public let nameArabic: String
    public let significance: String?
}
