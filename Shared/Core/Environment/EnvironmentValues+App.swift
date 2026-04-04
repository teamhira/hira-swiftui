//
//  EnvironmentValues+App.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = .init(
        theme: ThemeManager(),
        security: SecurityManager(),
        language: LanguageManager(),
        di: DIContainer.shared
    )
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
