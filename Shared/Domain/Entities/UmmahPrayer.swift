//
//  UmmahPrayer.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct UmmahLocationEntity: Codable, Equatable {
    public let latitude: Double
    public let longitude: Double
}

public struct UmmahPrayerTimesEntity: Codable, Equatable {
    public let imsak: String
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let isha: String
}

public struct UmmahPrayerStatusEntity: Codable, Equatable {
    public let currentPrayer: String
    public let nextPrayer: String
    public let timeUntilNext: String?
    public let minutesUntilNext: Int?
}

public struct UmmahCalculationMethodEntity: Codable, Identifiable, Equatable {
    public var id: String { name }
    public let name: String
    public let description: String
    public let fajrAngle: String?
    public let ishaAngle: String?
    public let ishaDescription: String?
    public let asrCalculation: String?
    public let madhab: String?
}

public struct UmmahMonthlyTimetableDayEntity: Codable, Equatable {
    public let date: String
    public let day: Int
    public let dayName: String
    public let prayerTimes: UmmahPrayerTimesEntity
}

public struct UmmahRamadanDayEntity: Codable, Equatable {
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
}

public struct UmmahPrayerIslamicInfoEntity: Codable, Equatable {
    public let prayerNames: [String: String]?
    public let note: String?
}
