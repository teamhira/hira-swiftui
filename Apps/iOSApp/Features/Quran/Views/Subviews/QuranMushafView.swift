//
//  QuranMushafView.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranMushafView: View {
    let pageNumber: Int
    @Environment(QuranViewModel.self) private var viewModel
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        let _ = viewModel.lastCacheUpdate // Force refresh on cache update
        let groups = viewModel.groupedAyahsForPage(pageNumber)
        let totalAyahsSize = groups.reduce(0) { $0 + $1.ayahs.count }
        let currentSurahNumber = groups.first?.surahNumber
            
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            if totalAyahsSize == 0 {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // 1. Top Surah Banner (as requested, replacing Juz detail)
                        if let surahNum = currentSurahNumber,
                           let surah = viewModel.surahs.first(where: { $0.number == surahNum }) {
                            let juzNum = groups.first?.ayahs.first?.juzNumber
                            VStack(spacing: 0) {
                                QuranHeritageHeader(surah: surah, juzNumber: juzNum)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 24)
                                
                                // Show Bismillah if surah starts at the top of the page
                                if groups.first?.ayahs.first?.number == 1 && 
                                   surah.number != 1 && surah.number != 9 {
                                    bismillahView
                                }
                            }
                        } else {
                            // Placeholder while surahs load
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colors.primary.opacity(0.05))
                                .frame(height: 66)
                                .overlay { 
                                    VStack(spacing: 8) {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                        if viewModel.surahs.isEmpty {
                                            Text("Loading Surahs...")
                                                .font(.system(size: 10))
                                                .foregroundColor(colors.primary.opacity(0.4))
                                        }
                                    }
                                }
                                .padding(.top, 16)
                                .padding(.horizontal, 24)
                        }
                        
                        VStack(spacing: 0) {
                            QuranMushafFlowLayout(spacing: 6) {
                                ForEach(groups, id: \.surahNumber) { group in
                                    // 2. Mid-page Surah Banner (if a new surah starts on this page)
                                    // Only show if it's NOT the first group on the page (already shown at top)
                                    if let surah = viewModel.surahs.first(where: { $0.number == group.surahNumber }),
                                       group.ayahs.contains(where: { $0.number == 1 }),
                                       group.surahNumber != currentSurahNumber {
                                        
                                        VStack(spacing: 0) {
                                            QuranHeritageHeader(surah: surah, juzNumber: group.ayahs.first?.juzNumber)
                                                .padding(.vertical, 12)
                                            
                                            if surah.number != 1 && surah.number != 9 {
                                                bismillahView
                                            }
                                        }
                                    }
                                    
                                    // 3. Ayahs & Words
                                    ForEach(group.ayahs, id: \.id) { ayah in
                                        let isActive = viewModel.activeAyah?.id == ayah.id
                                        
                                        // Filter out 'end' markers to avoid doubling with our custom seal
                                        let words = ayah.words.filter { w in
                                            w.charTypeName != "end" && w.text?.rangeOfCharacter(from: .decimalDigits) == nil
                                        }
                                        
                                        ForEach(words, id: \.id) { word in
                                            Text(renderWord(word))
                                                .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize))
                                                .foregroundColor(isActive ? colors.primary : colors.foreground)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(isActive ? colors.primary.opacity(0.12) : Color.clear)
                                                        .padding(.horizontal, -2)
                                                )
                                                .onTapGesture(count: 2) {
                                                    viewModel.selectedAyah = ayah
                                                    viewModel.showingAyahOptions = true
                                                }
                                                .onTapGesture(count: 1) {
                                                    withAnimation(.smooth) {
                                                        viewModel.activeAyah = ayah
                                                    }
                                                }
                                        }
                                        
                                        // Custom formatted end marker
                                        Text("﴾\(String(ayah.number).convertedToArabic())﴿")
                                            .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize * 0.8))
                                            .foregroundColor(isActive ? colors.primary : colors.primary.opacity(0.8))
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                            
                            // Page Number at bottom
                            HStack {
                                Spacer()
                                Text("\(String(pageNumber).convertedToArabic())")
                                    .font(.custom("KFGQPC Uthman Taha Naskh", size: 18))
                                    .foregroundColor(colors.primary)
                                    .padding(8)
                                    .background(
                                        Image(systemName: "seal")
                                            .font(.system(size: 32, weight: .light))
                                            .foregroundColor(colors.primary.opacity(0.2))
                                    )
                                Spacer()
                            }
                            .padding(.top, 40)
                        }
                        .padding(.horizontal, 24)
                        .environment(\.layoutDirection, .rightToLeft)
                        
                        Spacer(minLength: 180)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPage(pageNumber)
            if viewModel.surahs.isEmpty {
                let resolvedLang = appEnv.language.selectedCode == "system" 
                    ? (Locale.current.language.languageCode?.identifier ?? "en")
                    : appEnv.language.selectedCode
                viewModel.fetchSurahs(language: resolvedLang)
            }
        }
    }
    
    @ViewBuilder
    private var bismillahView: some View {
        HStack(spacing: 15) {
            lineDivider(isLeading: true).frame(maxWidth: 80)
            Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                .font(.custom("KFGQPC Uthman Taha Naskh", size: 24))
                .foregroundColor(colors.foreground)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .layoutPriority(1)
            lineDivider(isLeading: false).frame(maxWidth: 80)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
    
    private func lineDivider(isLeading: Bool) -> some View {
        HStack(spacing: 0) {
            if !isLeading {
                Image(systemName: "rhombus.fill")
                    .font(.system(size: 6))
                    .foregroundColor(colors.primary.opacity(0.3))
                    .rotationEffect(.degrees(45))
                    .padding(.trailing, 8)
            }
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        colors.primary.opacity(0),
                        colors.primary.opacity(0.4)
                    ]),
                    startPoint: isLeading ? .leading : .trailing,
                    endPoint: isLeading ? .trailing : .leading
                ))
                .frame(height: 1)
            if isLeading {
                Image(systemName: "rhombus.fill")
                    .font(.system(size: 6))
                    .foregroundColor(colors.primary.opacity(0.3))
                    .rotationEffect(.degrees(45))
                    .padding(.leading, 8)
            }
        }
    }
    
    private func renderWord(_ word: Word) -> AttributedString {
        if viewModel.showTajweed, let html = word.textTajweed {
            return TajweedRenderer.render(html: html)
        } else {
            return AttributedString(word.text ?? "")
        }
    }
}
