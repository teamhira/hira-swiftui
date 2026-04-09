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
            VStack(spacing: 24) {
                // Redesigned Last Reading Card
                if let recentSurah = viewModel.recentSurah {
                    LastReadingCard(surah: recentSurah, progress: viewModel.surahProgress)
                        .padding(.horizontal, 24)
                }
                
                // Surah List
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredSurahs) { surah in
                        NavigationLink(value: AppRoute.surahDetail(surah)) {
                            SurahCardView(surah: surah)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 16)
            
        case .juz:
            VStack(spacing: 24) {
                JuzProgressCard(
                    progress: viewModel.khatamProgress,
                    stats: String(format: appEnv.language.localizedString("quran_juz_khatam_stat"), 3),
                    lastRead: String(format: appEnv.language.localizedString("quran_juz_khatam_last"), "Juz 3 (Ali 'Imran)")
                )
                .padding(.horizontal, 24)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.juzList) { juz in
                        JuzRowView(juz: juz)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 16)
            
        case .bookmark:
            VStack(spacing: 24) {
                BookmarkHeaderCard(
                    count: viewModel.bookmarks.count,
                    lastRead: String(format: appEnv.language.localizedString("quran_bookmark_last"), "Al-Baqarah ayat 255")
                )
                .padding(.horizontal, 24)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.bookmarks) { bookmark in
                        BookmarkRowView(bookmark: bookmark)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 16)
        }
    }
}
