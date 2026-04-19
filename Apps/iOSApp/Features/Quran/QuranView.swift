//
//  QuranView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct QuranView: View {
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    
    public init() {}
    
    public var body: some View {
        @Bindable var viewModel = viewModel
        let colors = appEnv.theme.current
        ZStack(alignment: .bottom) {
            Color(colors.background).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Search & History
                QuranHeaderView(searchQuery: $viewModel.searchQuery, onHistoryTap: {
                    viewModel.showingHistory = true
                })
                
                // Content Switcher using Native TabView
                TabView(selection: $viewModel.selectedBottomTab) {
                    QuranSurahTabView(viewModel: viewModel)
                        .tag(QuranBottomTab.surah)
                    
                    QuranTopicTabView(viewModel: viewModel)
                        .tag(QuranBottomTab.topic)
                    
                    QuranDailyTabView(viewModel: viewModel)
                        .tag(QuranBottomTab.daily)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            // Custom Floating Tabs overlaying the TabView
            QuranBottomTabs(selectedTab: $viewModel.selectedBottomTab)
        }
        .sheet(isPresented: $viewModel.showingHistory) {
            QuranHistoryView(viewModel: viewModel)
        }
    }
}

#Preview {
    QuranView()
        .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
}
