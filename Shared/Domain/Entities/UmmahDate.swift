//
//  UmmahDate.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct HijriDate: Codable, Equatable {
    public let date: String
    public let formatted: String
    public let day: Int
    public let month: Int
    public let monthName: String
    public let monthNameArabic: String
    public let year: Int
    public let era: String?
}

public struct UmmahIslamicInfo: Codable, Equatable {
    public let hijriEraStart: String
    public let calendarType: String
    public let note: String
}

public struct GregorianDate: Codable, Equatable {
    public let date: String
    public let formatted: String
    public let dayOfWeek: String
    public let day: Int
    public let month: Int
    public let monthName: String
    public let year: Int
}

public struct UmmahDateConversion: Codable, Equatable {
    public let hijri: HijriDate
    public let gregorian: GregorianDate
    public let islamicInfo: UmmahIslamicInfo?
}

public struct UmmahIslamicMonth: Codable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let nameArabic: String
    public let significance: String?
}

public struct UmmahIslamicEvent: Codable, Equatable {
    public let title: String
    public let hijriDate: String
    public let gregorianDate: String
    public let month: Int
    public let day: Int
    public let description: String
}

