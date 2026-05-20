//
//  TrackerModels.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import Foundation

public enum TrackerItemType: String, Codable, CaseIterable, Identifiable {
    case fajr, dhuhr, asr, maghrib, isha
    case fasting
    case dhikr
    case quran
    case charity
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .fajr: return "sun.haze.fill"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .maghrib: return "moon.haze.fill"
        case .isha: return "moon.stars.fill"
        case .fasting: return "mouth.fill"
        case .dhikr: return "circle.grid.3x3.circle.fill"
        case .quran: return "book.closed.fill"
        case .charity: return "heart.fill"
        }
    }
    
    public var titleKey: String {
        switch self {
        case .fajr: return "tracker_item_fajr"
        case .dhuhr: return "tracker_item_dhuhr"
        case .asr: return "tracker_item_asr"
        case .maghrib: return "tracker_item_maghrib"
        case .isha: return "tracker_item_isha"
        case .fasting: return "tracker_item_fasting"
        case .dhikr: return "tracker_item_dhikr"
        case .quran: return "tracker_item_quran"
        case .charity: return "tracker_item_charity"
        }
    }
}

public struct TrackerEntry: Identifiable, Codable, Equatable {
    public let id: UUID
    public let type: TrackerItemType
    public var isCompleted: Bool
    public let date: Date
    
    public init(id: UUID = UUID(), type: TrackerItemType, isCompleted: Bool = false, date: Date = Date()) {
        self.id = id
        self.type = type
        self.isCompleted = isCompleted
        self.date = date
    }
}

public struct TrackerDayHistory: Identifiable, Codable {
    public var id: String { dateString }
    public let dateString: String // yyyy-MM-dd
    public let entries: [TrackerEntry]
    
    public var completionRate: Double {
        guard !entries.isEmpty else { return 0 }
        let completedCount = entries.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(entries.count)
    }
}
