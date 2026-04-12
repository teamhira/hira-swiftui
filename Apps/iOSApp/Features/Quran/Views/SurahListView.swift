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
            // MARK: - Last Reading Banner (Matching Juz/Bookmark Style)
            // Using viewModel.khatamProgress for now, or you could pass specific last read data
            JuzProgressCard(
                progress: viewModel.khatamProgress,
                stats: appEnv.language.localizedString("quran_last_reading"),
                lastRead: "Al-Baqarah ayat 255" // Placeholder, should come from viewModel
            )
            .padding(.horizontal, 24)
            
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
                }
            }
        }
        .padding(.horizontal, 24)
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
                .opacity(0.6)
            }
        }
        .padding(.horizontal, 24)
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
