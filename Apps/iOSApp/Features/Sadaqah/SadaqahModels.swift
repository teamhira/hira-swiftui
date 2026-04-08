//
//  SadaqahModels.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation

/// Supported Sadaqah categories.
public enum SadaqahType: String, CaseIterable, Identifiable {
    case subuh
    case cash
    case physical
    case waqf
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .subuh: return "sun.max.fill"
        case .cash: return "banknote.fill"
        case .physical: return "box.truck.fill"
        case .waqf: return "building.columns.fill"
        }
    }
    
    public var localizedTitleKey: String {
        "sadaqah_type_\(self.rawValue)_title"
    }
    
    public var localizedDescKey: String {
        "sadaqah_type_\(self.rawValue)_desc"
    }
}

public struct SadaqahCampaignItem: Identifiable {
    public let id = UUID()
    let title: String
    let category: String
    let progress: Double
    let description: String
}
