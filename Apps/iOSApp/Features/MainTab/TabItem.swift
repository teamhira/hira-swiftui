//
//  TabItem.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case home
    case quran
    case explore
    case charity
    case profile

    func localizedTitle(language: LanguageManager) -> String {
        switch self {
        case .home: return language.localizedString("tab_home")
        case .quran: return language.localizedString("tab_quran")
        case .explore: return language.localizedString("tab_explore")
        case .charity: return language.localizedString("tab_charity")
        case .profile: return language.localizedString("tab_profile")
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house"
        case .quran: return "book"
        case .explore: return "magnifyingglass"
        case .charity: return "heart"
        case .profile: return "person"
        }
    }

    var iconNameSelected: String {
        switch self {
        case .home: return "house.fill"
        case .quran: return "book.fill"
        case .explore: return "magnifyingglass"
        case .charity: return "heart.fill"
        case .profile: return "person.fill"
        }
    }
}
