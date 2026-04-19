//
//  QuranBookmarkListView.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import SwiftUI

public struct QuranBookmarkListView: View {
    var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    
    @State private var expandedSurahs: Set<Int> = []
    @State private var bookmarkToDelete: QuranBookmark? = nil
    @State private var showingDeleteAlert = false
    
    public init(viewModel: QuranViewModel) {
        self.viewModel = viewModel
    }
    
    private var groupedBookmarks: [Int: [QuranBookmark]] {
        Dictionary(grouping: viewModel.bookmarks, by: { $0.surahNumber })
    }
    
    private var sortedSurahKeys: [Int] {
        groupedBookmarks.keys.sorted()
    }
    
    private var lastReadText: String {
        if let reading = viewModel.readingBookmark {
            let surahName = viewModel.surahs.first(where: { $0.number == reading.key })?.name 
                ?? String(format: appEnv.language.localizedString("quran_surah_name_fallback"), reading.key)
            let ayahLabel = String(format: appEnv.language.localizedString("quran_surah_ayah_label"), surahName, reading.verseNumber ?? 0)
            return String(format: appEnv.language.localizedString("quran_bookmark_last"), ayahLabel)
        } else if !viewModel.bookmarks.isEmpty {
            return String(format: appEnv.language.localizedString("quran_bookmark_has_count"), viewModel.bookmarks.count)
        } else {
            return appEnv.language.localizedString("quran_bookmark_empty_collection")
        }
    }
    
    public var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            contentStack
                .onAppear(perform: handleOnAppear)
                .onChange(of: viewModel.bookmarks) { old, new in
                    handleBookmarksChange(old, new)
                }
                .alert(Text(appEnv.language.localizedString("quran_bookmark_delete_title")), isPresented: $showingDeleteAlert) {
                    deleteAlertButtons
                } message: {
                    deleteAlertMessage
                }
            
            // Toast Overlay
            if let toast = viewModel.toastMessage {
                VStack {
                    HiraToast(message: toast)
                        .padding(.top, 20)
                    Spacer()
                }
                .zIndex(100)
            }
        }
    }

    @ViewBuilder
    private var contentStack: some View {
        VStack(spacing: 24) {
            headerView
            
            if viewModel.bookmarks.isEmpty && !viewModel.isFetchingBookmarks {
                emptyState
            } else {
                bookmarkListView
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        BookmarkHeaderCard(
            count: viewModel.bookmarks.count,
            lastRead: lastReadText
        )
        .padding(.horizontal, 24)
        .redacted(reason: (viewModel.isFetchingBookmarks && viewModel.bookmarks.isEmpty) ? .placeholder : [])
    }
    
    @ViewBuilder
    private var bookmarkListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                if viewModel.isFetchingBookmarks && viewModel.bookmarks.isEmpty {
                    loadingView
                } else {
                    let grouped = groupedBookmarks
                    let keys = grouped.keys.sorted()
                    
                    ForEach(keys, id: \.self) { surahNumber in
                        if let surahBookmarks = grouped[surahNumber] {
                            surahGroupView(surahNumber: surahNumber, bookmarks: surahBookmarks)
                        }
                    }
                    
                    if viewModel.isFetchingBookmarks && !viewModel.bookmarks.isEmpty {
                        paginationLoader
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        ForEach(0..<5, id: \.self) { _ in
            BookmarkRowView(bookmark: placeholderBookmark)
                .redacted(reason: .placeholder)
        }
    }

    private var placeholderBookmark: QuranBookmark {
        QuranBookmark(surahNumber: 1, surahName: "Al-Fatihah", surahNameArabic: "", ayahNumber: 1, timeAgo: "2 days ago", arabicText: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
    }
    
    @ViewBuilder
    private var paginationLoader: some View {
        HStack {
            Spacer()
            ProgressView()
                .tint(colors.primary)
            Spacer()
        }
        .padding(.vertical, 20)
    }
    
    private func surahGroupView(surahNumber: Int, bookmarks: [QuranBookmark]) -> some View {
        let surahName = bookmarks.first?.surahName 
            ?? String(format: appEnv.language.localizedString("quran_surah_name_fallback"), surahNumber)
        
        return DisclosureGroup(
            isExpanded: expandedBinding(for: surahNumber),
            content: {
                groupContent(bookmarks: bookmarks)
            },
            label: {
                groupLabel(surahName: surahName, num: surahNumber, count: bookmarks.count)
            }
        )
        .accentColor(colors.primary)
    }

    private func expandedBinding(for surahNumber: Int) -> Binding<Bool> {
        Binding(
            get: { expandedSurahs.contains(surahNumber) },
            set: { isExpanded in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    if isExpanded {
                        expandedSurahs.insert(surahNumber)
                    } else {
                        expandedSurahs.remove(surahNumber)
                    }
                }
            }
        )
    }
    
    private func groupContent(bookmarks: [QuranBookmark]) -> some View {
        VStack(spacing: 10) { // Slightly tighter spacing
            ForEach(bookmarks) { bookmark in
                bookmarkButton(for: bookmark)
            }
        }
        .padding(.horizontal, 8)     // Enough for shadows
        .padding(.top, 8)           // Reduced distance from header
        .padding(.bottom, 20)       // Sufficient for last card shadow, reduced from 28
    }

    private func bookmarkButton(for bookmark: QuranBookmark) -> some View {
        Button(action: {
            navigateToBookmark(bookmark)
        }) {
            BookmarkRowView(bookmark: bookmark, onDelete: {
                bookmarkToDelete = bookmark
                showingDeleteAlert = true
            })
            .onAppear {
                if bookmark == viewModel.bookmarks.last {
                    viewModel.loadMoreBookmarks()
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func groupLabel(surahName: String, num: Int, count: Int) -> some View {
        HStack(spacing: 16) {
            // Styled Surah Number
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.12))
                    .frame(width: 36, height: 36)
                Text("\(num)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(surahName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("bookmark_ayah_group_desc"))
                    .font(.system(size: 11))
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            
            Spacer()
            
            // Count Badge with premium style
            HStack(spacing: 6) {
                Image(systemName: "bookmark.circle.fill")
                    .font(.system(size: 12))
                Text("\(count)")
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundColor(colors.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(colors.primary.opacity(0.1))
            )
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .hiraCleanCard(colors: colors, radius: 20)
    }
    
    @ViewBuilder
    private var deleteAlertButtons: some View {
        Button(appEnv.language.localizedString("quran_cancel"), role: .cancel) { }
        Button(appEnv.language.localizedString("quran_delete"), role: .destructive) {
            if let bookmark = bookmarkToDelete, let apiId = bookmark.apiId {
                viewModel.deleteBookmark(id: apiId)
            }
        }
    }
    
    private var deleteAlertMessage: some View {
        Text(String(format: appEnv.language.localizedString("quran_bookmark_delete_confirm"), bookmarkToDelete?.surahName ?? "", bookmarkToDelete?.ayahNumber ?? 0))
    }

    private func handleOnAppear() {
        viewModel.fetchBookmarks()
        // Expanded by default
        let surahKeys = groupedBookmarks.keys
        if !surahKeys.isEmpty {
            expandedSurahs = Set(surahKeys)
        }
    }

    private func handleBookmarksChange(_ old: [QuranBookmark], _ new: [QuranBookmark]) {
        // Ensure new additions are expanded by default
        let newKeys = Dictionary(grouping: new, by: { $0.surahNumber }).keys
        for key in newKeys {
            expandedSurahs.insert(key)
        }
    }
    
    private func navigateToBookmark(_ bookmark: QuranBookmark) {
        if let surah = viewModel.surahs.first(where: { $0.number == bookmark.surahNumber }) {
            // Try to find the real ayah in cache first, so we have pageNumber etc.
            let cachedAyah = viewModel.ayahCache[bookmark.surahNumber]?.first(where: { $0.number == bookmark.ayahNumber })
            
            let ayahSelection = cachedAyah ?? QuranAyah(
                surahNumber: bookmark.surahNumber,
                number: bookmark.ayahNumber,
                textArabic: bookmark.arabicText ?? "",
                textLatin: "",
                translation: "",
                words: [],
                pageNumber: nil,
                juzNumber: nil,
                isPlaceholder: true
            )
            
            // Ensure ViewModel knows this is the target BEFORE navigation
            viewModel.isRedirectedFromBookmark = true
            viewModel.activeAyah = ayahSelection
            
            withAnimation(.spring()) {
                router.path.append(AppRoute.surahDetail(surah, ayah: ayahSelection))
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
