//
//  QuranSurahTabView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct QuranSurahTabView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        VStack(spacing: 0) {
            // Top Native Segmented Picker
            QuranTopTabs(selectedTab: $viewModel.selectedTopTab)
                .transition(.move(edge: .top).combined(with: .opacity))
            
            ScrollView(showsIndicators: false) {
                content
                    .padding(.bottom, 150)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.selectedTopTab {
        case .surah:
            SurahListView(viewModel: viewModel)
                .padding(.top, 16)
            
        case .juz:
            QuranJuzListView(viewModel: viewModel)
                .padding(.top, 16)
            
        case .bookmark:
            QuranBookmarkListView(viewModel: viewModel)
                .padding(.top, 16)
        }
    }
}
