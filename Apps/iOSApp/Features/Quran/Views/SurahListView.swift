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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // MARK: - Last Reading Banner (Matching Juz/Bookmark Style)
                // Using viewModel.khatamProgress for now, or you could pass specific last read data
                JuzProgressCard(
                    progress: viewModel.khatamProgress,
                    stats: appEnv.language.localizedString("quran_last_reading"),
                    lastRead: "Al-Baqarah ayat 255" // Placeholder, should come from viewModel
                )
                .padding(.horizontal, 24)
                
                // MARK: - Surah List
                LazyVStack(spacing: 12) { // Tighter spacing as requested
                    ForEach(viewModel.filteredSurahs) { surah in
                        NavigationLink(value: AppRoute.surahDetail(surah)) {
                            surahRow(surah)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 16)
            .padding(.bottom, 120) // Space for player
        }
        .background(colors.background)
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
                
                Text(appEnv.language.localizedString("quran_ayah_count_label", arguments: [surah.versesCount, surah.versesCount]))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
            
            Spacer()
            
            Text(surah.nameArabic)
                .font(.custom("KFGQPC Uthman Taha Naskh", size: 20))
                .foregroundColor(colors.primary)
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("quran_accessibility_surah_card", arguments: [surah.name, surah.number, surah.versesCount]))
    }
}

#Preview {
    NavigationStack {
        SurahListView(viewModel: QuranViewModel())
    }
}
