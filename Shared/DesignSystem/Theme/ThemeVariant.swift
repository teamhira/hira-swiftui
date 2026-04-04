//
//  ThemeVariant.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public enum ThemeVariant: String, CaseIterable, Identifiable {
    case green
    case blue
    case brown
    case teal
    case pink

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .green: return "Forest Green"
        case .blue: return "Ocean Blue"
        case .brown: return "Earth Brown"
        case .teal: return "Calm Teal"
        case .pink: return "Cherry Blossom"
        }
    }

}
