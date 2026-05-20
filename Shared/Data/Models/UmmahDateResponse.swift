//
//  UmmahDateResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

// MARK: - API Models

public struct HijriDateInfo: Codable {
    public let date: String
    public let formatted: String
    public let day: Int
    public let month: Int
    public let monthName: String
    public let monthNameArabic: String
    public let year: Int
    public let era: String?

    enum CodingKeys: String, CodingKey {
        case date, formatted, day, month, year, era
        case monthName = "month_name"
        case monthNameArabic = "month_name_arabic"
    }
    
    func toDomain() -> HijriDate {
        .init(date: date, formatted: formatted, day: day, month: month, monthName: monthName, monthNameArabic: monthNameArabic, year: year, era: era)
    }
}

public struct GregorianDateInfo: Codable {
    public let date: String
    public let formatted: String
    public let dayOfWeek: String
    public let day: Int
    public let month: Int
    public let monthName: String
    public let year: Int

    enum CodingKeys: String, CodingKey {
        case date, formatted, day, month, year
        case dayOfWeek = "day_of_week"
        case monthName = "month_name"
    }
    
    func toDomain() -> GregorianDate {
        .init(date: date, formatted: formatted, dayOfWeek: dayOfWeek, day: day, month: month, monthName: monthName, year: year)
    }
}

public struct IslamicInfo: Codable {
    public let hijriEraStart: String
    public let calendarType: String
    public let note: String

    enum CodingKeys: String, CodingKey {
        case note
        case hijriEraStart = "hijri_era_start"
        case calendarType = "calendar_type"
    }

    func toDomain() -> UmmahIslamicInfo {
        .init(hijriEraStart: hijriEraStart, calendarType: calendarType, note: note)
    }
}

public struct TodayHijriResponse: Codable {
    public let hijri: HijriDateInfo
    public let gregorian: GregorianDateInfo
    public let islamicInfo: IslamicInfo?

    enum CodingKeys: String, CodingKey {
        case hijri, gregorian
        case islamicInfo = "islamic_info"
    }
    
    func toDomain() -> UmmahDateConversion {
        .init(hijri: hijri.toDomain(), gregorian: gregorian.toDomain(), islamicInfo: islamicInfo?.toDomain())
    }
}

public struct IslamicMonthResponse: Codable {
    public let number: Int
    public let nameEnglish: String
    public let nameArabic: String
    public let significance: String?

    enum CodingKeys: String, CodingKey {
        case number, significance
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
    }
    
    func toDomain() -> UmmahIslamicMonth {
        .init(id: number, name: nameEnglish, nameArabic: nameArabic, significance: significance)
    }
}

public struct IslamicMonthsResponse: Codable {
    public let months: [IslamicMonthResponse]

    enum CodingKeys: String, CodingKey {
        case months
    }
}

public struct IslamicEventResponse: Codable {
    public let month: Int
    public let day: Int
    public let name: String
    public let description: String
    public let hijriDate: String?
    public let gregorianDate: String?

    enum CodingKeys: String, CodingKey {
        case month, day, name, description
        case hijriDate = "hijri_date"
        case gregorianDate = "gregorian_date"
    }
    
    func toDomain() -> UmmahIslamicEvent {
        .init(title: name, hijriDate: hijriDate ?? "", gregorianDate: gregorianDate ?? "", month: month, day: day, description: description)
    }
}

public struct IslamicEventsResponse: Codable {
    public let events: [IslamicEventResponse]

    enum CodingKeys: String, CodingKey {
        case events
    }
}


public struct DateConversionResponse: Codable {
    public let hijri: HijriDateInfo
    public let gregorian: GregorianDateInfo
    
    func toDomain() -> UmmahDateConversion {
        .init(hijri: hijri.toDomain(), gregorian: gregorian.toDomain(), islamicInfo: nil)
    }
}
