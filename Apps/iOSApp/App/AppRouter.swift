//
//  AppRouter.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation

public enum AppRoute: Hashable {
    case splash
    case onboarding
    case login
    case register
    case forgotPassword
    case pin(PINMode)
    case home
    case editProfile
    case themeSetting
    case languageSetting
    case securitySetting
    case aboutHira
    case tasbih(Mission? = nil)
    case qibla
    case search
    case quranSearch
    case charitySearch
    case exploreSearch
    case surahDetail(Surah, ayah: QuranAyah? = nil)
    case startJourney
    case hijrahDashboard(JourneyState)
    case missionDetail(Mission, HijrahViewModel)
    case suggestionDetail(Suggestion)
    case chatbot
    case zakat
    case sadaqah
    case dua
    case hadith
    case achievements
    case mosques
    case khatam
    case deenMode
    case journal
    case tracker
    case calendar
    case halal
    case hajjJourney
    case hajjUmrah
    case prayerTimes
    case tarteel
    case tarteelRecitation(Surah)
    case tarteelHistory
    case duaList(String)
    case duaDetail(DuaItem)
    case hadithList(String)
    case hadithDetail(HadithItem)
    case articleList
    case articleDetail(Article)
}

@Observable
public class AppRouter {
    public var path = NavigationPath()
    
    public init() {}
    
    public func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
}
