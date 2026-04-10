//
//  HomeFeatureModel.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

public enum HomeFeatureType: String, CaseIterable, Codable, Identifiable {
    case zakat
    case sadaqah
    case qibla
    case tasbih
    case dua
    case hadith
    case achievements
    case mosques
    case khatam
    case deenMode
    case journal
    case askAI
    case tracker
    case calendar
    case halal
    case hajjJourney
    case hajjUmrah
    case prayerTimes
    case tarteel
    
    public var id: String { rawValue }
    
    public var titleKey: String {
        return "home_feature_\(rawValue.lowercased())"
    }
    
    public var descriptionKey: String? {
        switch self {
        case .mosques: return "mosque_search_desc"
        case .khatam: return "khatam_progress_desc"
        case .halal: return "halal_search_desc"
        default: return nil
        }
    }
    
    public var icon: String {
        switch self {
        case .zakat: return "banknote.fill"
        case .sadaqah: return "heart.fill"
        case .qibla: return "safari.fill"
        case .tasbih: return "circle.grid.3x3.circle.fill"
        case .dua: return "hands.sparkles.fill"
        case .hadith: return "book.closed.fill"
        case .achievements: return "trophy.fill"
        case .mosques: return "map.fill"
        case .khatam: return "book.fill"
        case .deenMode: return "moon.fill"
        case .journal: return "note.text"
        case .askAI: return "sparkle"
        case .tracker: return "chart.bar.fill"
        case .calendar: return "calendar"
        case .halal: return "fork.knife"
        case .hajjJourney: return "airplane"
        case .hajjUmrah: return "person.2.fill"
        case .prayerTimes: return "clock.fill"
        case .tarteel: return "waveform.and.mic"
        }
    }
}

public struct HomeFeatureModel: Identifiable, Codable, Equatable {
    public let type: HomeFeatureType
    public var isVisible: Bool
    
    public var id: String { type.id }
    
    public init(type: HomeFeatureType, isVisible: Bool = true) {
        self.type = type
        self.isVisible = isVisible
    }
}
