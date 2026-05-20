//
//  LanguageManager.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import Observation

@Observable
public class LanguageManager {
    private let key = "hira_app_language_code"
    
    public var selectedCode: String {
        didSet {
            UserDefaults.standard.set(selectedCode, forKey: key)
        }
    }
    
    public init() {
        self.selectedCode = UserDefaults.standard.string(forKey: key) ?? "system"
    }
    
    public var locale: Locale {
        if selectedCode == "system" {
            return .current
        }
        return Locale(identifier: selectedCode)
    }
    
    public var layoutDirection: LayoutDirection {
        if selectedCode == "system" {
            // Check current system layout direction
            let langCode = Locale.current.language.languageCode?.identifier ?? "en"
            return Locale.Language(identifier: langCode).characterDirection == .rightToLeft ? .rightToLeft : .leftToRight
        }
        return selectedCode == "ar" ? .rightToLeft : .leftToRight
    }
    
    public func setLanguage(_ code: String) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            selectedCode = code
        }
    }
    
    public func localizedString(_ key: String, fallback: String? = nil, arguments: [CVarArg] = []) -> String {
        let bundle: Bundle
        if selectedCode == "system" {
            bundle = .main
        } else {
            if let path = Bundle.main.path(forResource: selectedCode, ofType: "lproj"),
               let langBundle = Bundle(path: path) {
                bundle = langBundle
            } else {
                bundle = .main
            }
        }
        
        let localizedValue = NSLocalizedString(key, bundle: bundle, value: fallback ?? key, comment: "")
        
        if arguments.isEmpty {
            return localizedValue
        }
        
        return String(format: localizedValue, locale: self.locale, arguments: arguments)
    }
}
