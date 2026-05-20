//
//  HiraApp.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
@main
struct HiraApp: App {
    @State private var router = AppRouter()
    @State private var appState = AppState()
    @State private var theme = ThemeManager()
    @State private var security = SecurityManager()
    @State private var language = LanguageManager()
    @State private var quranViewModel = QuranViewModel()
    
    public init() {
        // Initialize notification manager and delegate
        _ = NotificationManager.shared
        NotificationManager.shared.requestAuthorization()
    }

    
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
                                    case .pin(let mode): PINView(mode: mode)
                                    case .editProfile: EditProfileView()
                                    case .themeSetting: ThemeSettingView()
                                    case .languageSetting: LanguageSettingView()
                                    case .securitySetting: SecuritySettingView()
                                    case .aboutHira: AboutHiraView()
                                    case .tasbih(let mission): TasbihView(mission: mission)
                                    case .qibla: QiblaView()
                                    case .search: GlobalSearchView()
                                    case .quranSearch: GlobalQuranSearchView()
                                    case .charitySearch: GlobalCharitySearchView()
                                    case .exploreSearch: GlobalExploreSearchView()
                                    case .surahDetail(let surah, let ayah): SurahDetailView(surah: surah, initialAyah: ayah)
                                    case .startJourney: StartJourneyView()
                                    case .hijrahDashboard(let state): HijrahView(state: state)
                                    case .missionDetail(let mission, let vm): MissionDetailView(mission: mission, viewModel: vm)
                                    case .suggestionDetail(let suggestion): SuggestionDetailView(suggestion: suggestion)
                                    case .chatbot: ChatbotView()
                                    case .zakat: ZakatView()
                                    case .sadaqah: SadaqahView()
                                    case .dua: DuaView()
                                    case .duaList(let category): DuaListView(category: category)
                                    case .duaDetail(let item): DuaDetailView(item: item)
                                    case .hadith: HadithView()
                                    case .hadithList(let category): HadithListView(category: category)
                                    case .hadithDetail(let item): HadithDetailView(item: item)
                                    case .achievements: AchievementsView()
                                    case .mosques: MosquesView()
                                    case .khatam: KhatamView()
                                    case .deenMode: DeenModeView()
                                    case .journal: JournalView()
                                    case .tracker: TrackerView()
                                    case .calendar: CalendarView()
                                    case .halal: HalalView()
                                    case .allahNames: AllahNamesView()
                                    case .memorization: MemorizationView()
                                    case .articleList: ArticleListView()
                                    case .articleDetail(let article): ArticleDetailView(article: article)
                                    case .home, .splash: EmptyView()
                                    case .prayerTimes: PrayerTimesView()
                                    case .tarteel: TarteelView()
                                    case .tarteelRecitation(let surah): TarteelRecitationView(viewModel: TarteelViewModel(), surah: surah)
                                    case .tarteelHistory: TarteelHistoryView(viewModel: TarteelViewModel())
                                    }
                                }
                        }
                    }
                }
            }
            .id(language.selectedCode)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HIRA_DEEP_LINK"))) { note in
                if let feature = note.object as? String, feature == "deenmode" {
                    router.navigate(to: .deenMode)
                }
            }
            .environment(quranViewModel)
            .environment(router)
            .environment(appState)
            .environment(\.appEnvironment, AppEnvironment(theme: theme, security: security, language: language, di: DIContainer.shared))
            .environment(\.locale, language.locale)
            .environment(\.layoutDirection, language.layoutDirection)
        }
    }
}
