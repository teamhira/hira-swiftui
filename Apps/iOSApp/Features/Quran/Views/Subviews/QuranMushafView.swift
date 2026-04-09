//
//  QuranMushafView.swift
//  Hira
//
//  Created by Antigravity on 08/04/26.
//

import SwiftUI

struct QuranMushafView: View {
    let surah: Surah
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        let ayahs = viewModel.ayahs(for: surah)
        
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Mushaf Top Margin (Juz & Title) - Now ABOVE Banner
                    HStack {
                        Text("Juz' \(currentJuz)")
                            .font(.system(size: 13, weight: .medium, design: .serif))
                        Spacer()
                        Text(surah.name)
                            .font(.system(size: 13, weight: .medium, design: .serif))
                    }
                    .foregroundColor(colors.foreground.opacity(0.4))
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                    // MARK: - Heritage Surah Header (Banner)
                    QuranHeritageHeader(surah: surah)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    
                    // MARK: - Justified Continuous Text
                    QuranMushafFlowLayout(spacing: 8) {
                        ForEach(ayahIndices(for: ayahs), id: \.1) { (word, id, ayah) in
                            Text(word)
                                .font(.custom("KFGQPC Uthman Taha Naskh", size: 30))
                                .foregroundColor(colors.foreground)
                                .onTapGesture {
                                    viewModel.selectedAyah = ayah
                                    viewModel.showingAyahOptions = true
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Mushaf Page Number
                    Text("\(String(surah.number).convertedToArabic())")
                        .font(.system(size: 14, weight: .medium, design: .serif))
                        .foregroundColor(colors.foreground.opacity(0.3))
                        .padding(.top, 40)
                        .padding(.bottom, 180) // Space for player
                }
            }
        }
    }
    
    private var currentJuz: Int { 1 } // Logic placeholder
    
    private func ayahIndices(for ayahs: [QuranAyah]) -> [(String, String, QuranAyah)] {
        var result: [(String, String, QuranAyah)] = []
        for ayah in ayahs {
            let words = ayah.textArabic.components(separatedBy: .whitespaces)
            for (index, word) in words.enumerated() {
                result.append((word, "\(ayah.id)_w\(index)", ayah))
            }
            let marker = "﴾\(String(ayah.number).convertedToArabic())﴿"
            result.append((marker, "\(ayah.id)_marker", ayah))
        }
        return result
    }
}
