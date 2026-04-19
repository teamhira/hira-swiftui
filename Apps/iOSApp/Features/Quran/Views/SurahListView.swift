//
//  SurahListView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahListView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(viewModel: QuranViewModel) {
        self._viewModel = Bindable(viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            // MARK: - Last Reading Banner
            lastReadingBanner
            
            // MARK: - List Content
            if viewModel.isLoading && viewModel.surahs.isEmpty {
                loadingState
            } else if let error = viewModel.errorMessage {
                errorState(error)
            } else if viewModel.filteredSurahs.isEmpty {
                emptyState
            } else {
                surahList
            }
        }
        .onAppear {
            viewModel.fetchReadingSessions()
            if viewModel.surahs.isEmpty {
                let currentLang = appEnv.language.selectedCode
                let languageCode = currentLang == "system" 
                    ? (Locale.current.language.languageCode?.identifier ?? "en") 
                    : currentLang
                viewModel.fetchSurahs(language: languageCode)
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var lastReadingBanner: some View {
        if viewModel.isFetchingReadingSessions && viewModel.readingSessions.isEmpty {
            // Skeleton loading state
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.07))
                        .frame(width: 90, height: 12)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.07))
                        .frame(width: 140, height: 20)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colors.foreground.opacity(0.07))
                        .frame(width: 100, height: 12)
                }
                Spacer()
                Circle()
                    .fill(colors.foreground.opacity(0.07))
                    .frame(width: 80, height: 80)
            }
            .padding(24)
            .hiraCleanCard(colors: colors, radius: 28)
            .padding(.horizontal, 24)
        } else if let session = viewModel.readingSessions.first,
                  let surah = viewModel.surahs.first(where: { $0.number == session.chapterNumber }) {
            // Progress: (verseNumber - 1) / versesCount so that ayah 1 = 0% and last ayah = 100%
            let progress = surah.versesCount > 1
                ? min(Double(session.verseNumber - 1) / Double(surah.versesCount - 1), 1.0)
                : 0.0
            LastReadingCard(surah: surah, progress: progress)
                .padding(.horizontal, 24)
        } else if !viewModel.isFetchingReadingSessions {
            // No reading history yet
            noLastReadingCard
                .padding(.horizontal, 24)
        }
    }
    
    private var noLastReadingCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 32))
                .foregroundStyle(colors.primary.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appEnv.language.localizedString("quran_last_reading"))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(colors.primary)
                Text(appEnv.language.localizedString("quran_bookmark_no_last"))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(colors.foreground)
                Text(appEnv.language.localizedString("quran_reading_start_cta"))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.45))
            }
            Spacer()
        }
        .padding(20)
        .hiraCleanCard(colors: colors, radius: 28)
    }
    
    private func surahRow(_ surah: Surah) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                Text("\(surah.number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(surah.name)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("quran_verses_count", arguments: [surah.versesCount]))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(surah.nameArabic)
                    .font(.custom("KFGQPC Uthman Taha Naskh", size: 20))
                    .foregroundColor(colors.primary)
                
                Text(surah.nameTranslation)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.foreground.opacity(0.3))
            }
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("quran_accessibility_surah_card", arguments: [surah.name, surah.number, surah.versesCount]))
    }
    
    // MARK: - State Subviews
    
    private var surahList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredSurahs) { surah in
                NavigationLink(value: AppRoute.surahDetail(surah)) {
                    surahRow(surah)
                        .padding(.horizontal, 24)
                }
            }
        }
        .padding(.bottom, 40)
    }
    
    private var loadingState: some View {
        VStack(spacing: 12) {
            ForEach(0..<8) { _ in
                HStack(spacing: 16) {
                    Circle()
                        .fill(colors.foreground.opacity(0.05))
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colors.foreground.opacity(0.05))
                            .frame(width: 120, height: 14)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colors.foreground.opacity(0.05))
                            .frame(width: 80, height: 10)
                    }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colors.foreground.opacity(0.05))
                        .frame(width: 60, height: 24)
                }
                .padding(16)
                .hiraCleanCard(colors: colors, radius: 24)
                .padding(.horizontal, 24)
                .opacity(0.6)
            }
        }
        .overlay(
            ProgressView()
                .padding(.top, 100)
                .scaleEffect(1.2)
        )
    }
    
    private func errorState(_ message: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(colors.primary.gradient)
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("error_view_title"))
                    .font(.title3.bold())
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { viewModel.fetchSurahs() }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text(appEnv.language.localizedString("error_view_retry_button"))
                }
            }
            .hiraPrimaryButton(colors: colors)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(colors.foreground.opacity(0.1))
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("empty_search_title"))
                    .font(.title3.bold())
                Text(appEnv.language.localizedString("empty_search_desc"))
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        SurahListView(viewModel: QuranViewModel())
    }
}
