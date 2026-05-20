//
//  MainTabView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
public struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @Environment(\.appEnvironment) private var appEnv
    
    private var theme: ThemeManager { appEnv.theme }
    private var colors: ThemeModel { theme.current }
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                viewForTab(tab)
                    .tabItem {
                        Image(systemName: selectedTab == tab ? tab.iconNameSelected : tab.iconName)
                            .environment(\.symbolVariants, selectedTab == tab ? .fill : .none)
                        Text(tab.localizedTitle(language: appEnv.language))
                    }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder
    private func viewForTab(_ tab: Tab) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .quran:
            QuranView()
        case .explore:
            ExploreView()
        case .charity:
            CharityView()
        case .profile:
            ProfileView(theme: theme)
        }
    }
}

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
#Preview {
    MainTabView()
}
