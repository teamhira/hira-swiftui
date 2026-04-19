//
//  SurahDetailView+Reader.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

extension SurahDetailView {
    @ViewBuilder
    var readerView: some View {
        @Bindable var viewModel = viewModel
        if viewModel.readingMode == .list {
            PageCurlView(items: viewModel.surahs, currentItem: $currentSurah) { surah in
                surahContentView(for: surah)
                    .environment(viewModel)
                    .environment(\.appEnvironment, appEnv)
                    .id("list_\(surah.id)")
            }
            .id("list_mode")
            .ignoresSafeArea()
        } else {
            PageCurlView(items: allPages, currentItem: $currentPage) { page in
                QuranMushafView(pageNumber: page.number)
                    .environment(viewModel)
                    .environment(\.appEnvironment, appEnv)
                    .id("mushaf_\(page.number)")
            }
            .id("mushaf_mode")
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func surahContentView(for surah: Surah) -> some View {
        QuranAyahListView(
            surah: surah,
            currentSurah: $currentSurah,
            pullUpOffset: $pullUpOffset,
            pullDownOffset: $pullDownOffset,
            onNextSurah: {
                withAnimation(.easeInOut) {
                    nextSurah()
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            },
            onPrevSurah: {
                withAnimation(.easeInOut) {
                    prevSurah()
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            }
        )
    }
}
