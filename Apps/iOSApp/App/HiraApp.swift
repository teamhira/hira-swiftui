//
//  HiraApp.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

@main
struct HiraApp: App {
    @State private var router = AppRouter()
    @State private var appState = AppState()
    @State private var theme = ThemeManager()
    @State private var security = SecurityManager()
    @State private var language = LanguageManager()
    
    public init() {}
    
    var body: some Scene {
        WindowGroup {
            Group {
                AppContainerView {
                    if appState.showSplash {
                        SplashView()
                    } else {
                        NavigationStack(path: $router.path) {
                            MainTabView()
                                .navigationDestination(for: AppRoute.self) { route in
                                    switch route {
                                    case .onboarding: OnboardingView()
                                    case .login: LoginView()
                                    case .register: RegisterView()
                                    case .forgotPassword: ForgotPasswordView()
                                    case .pin(let mode): PINView(mode: mode)
                                    case .editProfile: EditProfileView()
                                    case .themeSetting: ThemeSettingView()
                                    case .languageSetting: LanguageSettingView()
                                    case .securitySetting: SecuritySettingView()
                                    case .aboutHira: AboutHiraView()
                                    case .tasbih: TasbihView()
                                    case .qibla: QiblaView()
                                    case .search: GlobalSearchView()
                                    case .charitySearch: GlobalCharitySearchView()
                                    case .exploreSearch: GlobalExploreSearchView()
                                    case .surahDetail(let surah): SurahDetailView(surah: surah)
                                    case .home, .splash: EmptyView()
                                    }
                                }
                        }
                    }
                }
            }
            .id(language.selectedCode)
            .environment(router)
            .environment(appState)
            .environment(\.appEnvironment, AppEnvironment(theme: theme, security: security, language: language, di: DIContainer.shared))
            .environment(\.locale, language.locale)
            .environment(\.layoutDirection, language.layoutDirection)
        }
    }
}
