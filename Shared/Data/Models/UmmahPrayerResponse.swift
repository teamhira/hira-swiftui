//
//  UmmahPrayerResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

// MARK: - API Models

public struct LocationResponse: Codable {
    public let latitude: Double
    public let longitude: Double
    
    func toDomain() -> UmmahLocationEntity {
        .init(latitude: latitude, longitude: longitude)
    }
}

public struct PrayerTimesModel: Codable {
    public let imsak: String
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let isha: String
    
    func toDomain() -> UmmahPrayerTimesEntity {
        .init(imsak: imsak, fajr: fajr, sunrise: sunrise, dhuhr: dhuhr, asr: asr, maghrib: maghrib, isha: isha)
    }
    
    func toMap() -> [String: String] {
        [
            "imsak": imsak,
            "fajr": fajr,
            "sunrise": sunrise,
            "dhuhr": dhuhr,
            "asr": asr,
            "maghrib": maghrib,
            "isha": isha
        ]
    }
}

public struct PrayerTimesResponse: Codable {
    public let date: String
    public let timezone: String
    public let location: LocationResponse
    public let calculationMethod: String
    public let madhab: String
    public let prayerTimes: PrayerTimesModel
    public let islamicInfo: PrayerIslamicInfo?
    public let currentStatus: PrayerCurrentStatus?

    enum CodingKeys: String, CodingKey {
        case date, timezone, location, madhab
        case calculationMethod = "calculation_method"
        case prayerTimes = "prayer_times"
        case islamicInfo = "islamic_info"
        case currentStatus = "current_status"
    }
}

public struct PrayerIslamicInfo: Codable {
    public let prayerNames: [String: String]?
    public let note: String?
    
    enum CodingKeys: String, CodingKey {
        case prayerNames = "prayer_names"
        case note
    }
    
    func toDomain() -> UmmahPrayerIslamicInfoEntity {
        .init(prayerNames: prayerNames, note: note)
    }
}

public struct PrayerCurrentStatus: Codable {
    public let currentPrayer: String
    public let nextPrayer: String
    public let timeUntilNext: String?
    public let minutesUntilNext: Int?

    enum CodingKeys: String, CodingKey {
        case currentPrayer = "current_prayer"
        case nextPrayer = "next_prayer"
        case timeUntilNext = "time_until_next"
        case minutesUntilNext = "minutes_until_next"
    }
    
    func toDomain() -> UmmahPrayerStatusEntity {
        .init(
            currentPrayer: currentPrayer,
            nextPrayer: nextPrayer,
            timeUntilNext: timeUntilNext ?? "",
            minutesUntilNext: minutesUntilNext ?? 0
        )
    }
}

public struct MonthlyTimetableDayResponse: Codable {
    public let date: String
    public let day: Int
    public let dayName: String
    public let prayerTimes: PrayerTimesModel

    enum CodingKeys: String, CodingKey {
        case date, day
        case dayName = "day_name"
        case prayerTimes = "prayer_times"
    }
    
    func toDomain() -> UmmahMonthlyTimetableDayEntity {
        .init(date: date, day: day, dayName: dayName, prayerTimes: prayerTimes.toDomain())
    }
}

public struct MonthlyTimetableResponse: Codable {
    public let location: LocationResponse
    public let timezone: String
    public let month: Int
    public let year: Int
    public let monthName: String
    public let calculationMethod: String
    public let madhab: String
    public let totalDays: Int
    public let days: [MonthlyTimetableDayResponse]

    enum CodingKeys: String, CodingKey {
        case location, timezone, month, year, madhab
        case monthName = "month_name"
        case calculationMethod = "calculation_method"
        case totalDays = "total_days"
        case days
    }
}

public struct RamadanTimetableDayResponse: Codable {
    public let day: Int
    public let date: String
    public let dayName: String
    public let hijriDate: String
    public let third: String
    public let suhoorEnds: String
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let iftar: String
    public let maghrib: String
    public let isha: String

    enum CodingKeys: String, CodingKey {
        case day, date, third, fajr, sunrise, dhuhr, asr, iftar, maghrib, isha
        case dayName = "day_name"
        case hijriDate = "hijri_date"
        case suhoorEnds = "suhoor_ends"
    }
    
    func toDomain() -> UmmahRamadanDayEntity {
        .init(day: day, date: date, dayName: dayName, hijriDate: hijriDate, third: third, suhoorEnds: suhoorEnds, fajr: fajr, sunrise: sunrise, dhuhr: dhuhr, asr: asr, iftar: iftar, maghrib: maghrib, isha: isha)
    }
}

public struct RamadanTimetableResponse: Codable {
    public let location: LocationResponse
    public let timezone: String
    public let year: Int
    public let hijriYear: Int
    public let calculationMethod: String
    public let madhab: String
    public let ramadanDays: Int
    public let ramadanStart: String
    public let ramadanEnd: String
    public let days: [RamadanTimetableDayResponse]

    enum CodingKeys: String, CodingKey {
        case location, timezone, year, madhab, days
        case hijriYear = "hijri_year"
        case calculationMethod = "calculation_method"
        case ramadanDays = "ramadan_days"
        case ramadanStart = "ramadan_start"
        case ramadanEnd = "ramadan_end"
    }
}

public struct CalculationMethodModel: Codable {
    public let name: String
    public let description: String
    public let fajrAngle: String?
    public let ishaAngle: String?
    public let ishaDescription: String?
    public let asrCalculation: String?
    public let madhab: String?

    enum CodingKeys: String, CodingKey {
        case name, description, madhab
        case fajrAngle = "fajr_angle"
        case ishaAngle = "isha_angle"
        case ishaDescription = "isha_description"
        case asrCalculation = "asr_calculation"
    }
    
    func toDomain() -> UmmahCalculationMethodEntity {
        .init(name: name, description: description, fajrAngle: fajrAngle, ishaAngle: ishaAngle, ishaDescription: ishaDescription, asrCalculation: asrCalculation, madhab: madhab)
    }
}

public struct CalculationMethodsResponse: Codable {
    public let methods: [String: CalculationMethodModel]
    public let defaultMethod: String
    public let usage: String

    enum CodingKeys: String, CodingKey {
        case methods, usage
        case defaultMethod = "default_method"
    }
}
