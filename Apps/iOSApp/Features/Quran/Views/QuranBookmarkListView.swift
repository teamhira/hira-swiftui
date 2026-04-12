//
//  QuranBookmarkListView.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import SwiftUI

public struct QuranBookmarkListView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(viewModel: QuranViewModel) {
        self._viewModel = Bindable(viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            BookmarkHeaderCard(
                count: viewModel.bookmarks.count,
                lastRead: String(format: appEnv.language.localizedString("quran_bookmark_last"), "Al-Baqarah ayat 255")
            )
            .padding(.horizontal, 24)
            
            if viewModel.bookmarks.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.bookmarks) { bookmark in
                        BookmarkRowView(bookmark: bookmark)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 60))
                .foregroundStyle(colors.foreground.opacity(0.1))
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("quran_no_bookmarks_title"))
                    .font(.title3.bold())
                Text(appEnv.language.localizedString("quran_no_bookmarks_desc"))
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(60)
    }
}
