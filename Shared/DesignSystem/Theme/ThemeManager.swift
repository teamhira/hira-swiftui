//
//  ThemeManager.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class ThemeManager {

    // MARK: - State
    var variant: ThemeVariant {
        didSet { saveTheme(variant) }
    }
    var isDark: Bool {
        didSet { saveDarkMode(isDark) }
    }

    // MARK: - Storage Keys
    private static let themeKey = "app_theme"
    private static let darkModeKey = "app_dark_mode"

    // MARK: - Init
    init() {
        self.variant = Self.loadTheme()
        self.isDark = Self.loadDarkMode()
    }

    // MARK: - Current Theme
    var current: ThemeModel {
        ThemeFactory.make(variant, isDark: isDark)
    }

    // MARK: - Actions
    func setTheme(_ variant: ThemeVariant) {
        self.variant = variant
    }

    func toggleDarkMode() {
        isDark.toggle()
    }

    // MARK: - Persistence
    private func saveTheme(_ variant: ThemeVariant) {
        UserDefaults.standard.set(variant.rawValue, forKey: Self.themeKey)
    }

    private func saveDarkMode(_ isDark: Bool) {
        UserDefaults.standard.set(isDark, forKey: Self.darkModeKey)
    }

    private static func loadTheme() -> ThemeVariant {
        let value = UserDefaults.standard.string(forKey: themeKey)
        return ThemeVariant(rawValue: value ?? "") ?? .green
    }

    private static func loadDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: darkModeKey)
    }
}
