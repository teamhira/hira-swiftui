//
//  DeenModeModels.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import Foundation

public enum DeenFocusType: String, Codable, CaseIterable, Identifiable {
    case quran, dhikr, salah, study
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .quran: return "book.closed.fill"
        case .dhikr: return "circle.grid.3x3.circle.fill"
        case .salah: return "person.fill.viewfinder"
        case .study: return "graduationcap.fill"
        }
    }
    
    public var titleKey: String {
        switch self {
        case .quran: return "deenmode_focus_quran"
        case .dhikr: return "deenmode_focus_dhikr"
        case .salah: return "deenmode_focus_salah"
        case .study: return "deenmode_focus_study"
        }
    }
}

public struct DeenSetting: Identifiable, Codable {
    public let id: UUID
    public let titleKey: String
    public let descKey: String
    public let icon: String
    public var isActive: Bool
    
    public init(id: UUID = UUID(), titleKey: String, descKey: String, icon: String, isActive: Bool = false) {
        self.id = id
        self.titleKey = titleKey
        self.descKey = descKey
        self.icon = icon
        self.isActive = isActive
    }
}

public struct DeenFocusSession: Identifiable, Codable {
    public let id: UUID
    public let type: DeenFocusType
    public let startTime: Date
    public var endTime: Date?
    public var durationSeconds: Int
    
    public init(id: UUID = UUID(), type: DeenFocusType, startTime: Date = Date(), durationSeconds: Int = 0) {
        self.id = id
        self.type = type
        self.startTime = startTime
        self.durationSeconds = durationSeconds
    }
}
