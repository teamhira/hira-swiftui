//
//  QuranAyahCard.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranAyahCard: View {
    let ayah: QuranAyah
    let viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    
    private var isPlaying: Bool {
        viewModel.recitationManager.status == .playing && viewModel.recitationManager.activeVerseKey == "\(ayah.surahNumber):\(ayah.number)"
    }
    
    private var isActive: Bool {
        viewModel.activeAyah?.id == ayah.id
    }
    
    private var activeWordIndex: Int? {
        viewModel.recitationManager.activeWordIndex
    }
    
    var body: some View {
        let colors = appEnv.theme.current
        
        VStack(alignment: .leading, spacing: 24) {
            // Arabic Verse - Explicitly right-aligned
            arabicTextView(colors: colors)
            
            // Info Section - Latin/Translation - Explicitly left-aligned
            infoSectionView(colors: colors)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                if isPlaying {
                    colors.primary.opacity(0.12)
                } else if isActive {
                    colors.primary.opacity(0.06)
                } else {
                    colors.background
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            viewModel.selectedAyah = ayah
            viewModel.showingAyahOptions = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        .onTapGesture(count: 1) {
            // ONLY activates the current ayah (visual selection). 
            // Audio does NOT play on single tap of the card (user request).
            withAnimation(.easeInOut) {
                viewModel.activeAyah = ayah
            }
        }
        .overlay(
            Rectangle()
                .fill(colors.primary.opacity(0.05))
                .frame(height: 1)
                .frame(maxWidth: .infinity, alignment: .bottom),
            alignment: .bottom
        )
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func arabicTextView(colors: ThemeModel) -> some View {
        QuranFlowLayout(spacing: 12) {
            let wordsToProcess = ayah.words.filter { $0.charTypeName != "end" && $0.text?.rangeOfCharacter(from: .decimalDigits) == nil }
            
            ForEach(Array(wordsToProcess.enumerated()), id: \.offset) { index, word in
                let isWordActive = isPlaying && activeWordIndex == (index + 1)
                let content = renderWord(word)
                let hasTajweed = viewModel.showTajweed && word.textTajweed != nil
                
                Text(content)
                    .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize))
                    .foregroundColor(isWordActive ? colors.primary : (hasTajweed ? nil : colors.foreground))
                    .background(isWordActive ? colors.primary.opacity(0.15) : Color.clear)
                    // WORD AUDIO DISABLED HERE (Per user request: Words should only trigger audio from secondary cards)
            }
            
            Text("﴾\(String(ayah.number).convertedToArabic())﴿")
                .font(.custom("KFGQPC Uthman Taha Naskh", size: viewModel.textSize * 0.8))
                .foregroundColor(colors.primary)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 5)
    }
    
    @ViewBuilder
    private func infoSectionView(colors: ThemeModel) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 14) {
                if viewModel.showTransliteration {
                    Text(ayah.textLatin)
                        .font(.system(size: max(13, viewModel.textSize * 0.5), weight: .semibold, design: .serif))
                        .foregroundColor(colors.primary.opacity(0.7))
                        .italic()
                        .multilineTextAlignment(.leading)
                }
                
                if viewModel.showTranslation {
                    Text(ayah.translation)
                        .font(.system(size: max(14, viewModel.textSize * 0.55)))
                        .foregroundColor(colors.foreground.opacity(0.8))
                        .lineSpacing(viewModel.textSize * 0.2)
                        .multilineTextAlignment(.leading)
                }
            }
            
            // Word by Word Cards
            if viewModel.showWordByWord {
                wordByWordSection(colors: colors)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func wordByWordSection(colors: ThemeModel) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                let wordsToProcess = ayah.words.filter { $0.charTypeName != "end" && $0.text?.rangeOfCharacter(from: .decimalDigits) == nil }
                
                ForEach(wordsToProcess) { word in
                    VStack(spacing: 8) {
                        Text(word.text ?? "")
                            .font(.custom("KFGQPC Uthman Taha Naskh", size: 22))
                            .foregroundColor(colors.primary)
                        
                        VStack(spacing: 2) {
                            Text(word.transliteration ?? "")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(colors.foreground.opacity(0.6))
                            
                            Text(word.translation ?? "")
                                .font(.system(size: 10))
                                .foregroundColor(colors.foreground.opacity(0.4))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(colors.primary.opacity(0.04))
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Word audio triggers strictly from these cards only
                        viewModel.recitationManager.playWords([word])
                    }
                }
            }
        }
        .padding(.top, 4)
    }
    
    private func renderWord(_ word: Word) -> AttributedString {
        if viewModel.showTajweed, let html = word.textTajweed {
            return TajweedRenderer.render(html: html)
        } else {
            return AttributedString(word.text ?? "")
        }
    }
}
