//
//  QuranHeritageHeader.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranHeritageHeader: View {
    let surah: Surah
    var juzNumber: Int? = nil
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            // Main Container
            RoundedRectangle(cornerRadius: 16)
                .fill(colors.primary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [colors.primary.opacity(0.4), colors.primary.opacity(0.1), colors.primary.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            // Corner Ornaments
            cornerOrnaments
            
            VStack(spacing: 4) {
                HStack(alignment: .center) {
                    // Left: Revelation Info
                    VStack(alignment: .leading, spacing: 0) {
                        if let juz = juzNumber {
                            Text(String(format: NSLocalizedString("quran_juz_number", comment: ""), juz).uppercased())
                                .foregroundColor(colors.primary)
                        }
                        Text(surah.revelationPlace.uppercased())
                        Text(String(format: NSLocalizedString("quran_verses_count", comment: ""), surah.versesCount).uppercased())
                    }
                    .font(.system(size: 7, weight: .black))
                    .foregroundColor(colors.primary.opacity(0.7))
                    .frame(width: 70, alignment: .leading)
                    
                    Spacer()
                    
                    // Center: Arabic Name
                    Text(surah.nameArabic)
                        .font(.custom("KFGQPC Uthman Taha Naskh", size: 24))
                        .foregroundColor(colors.primary)
                        .offset(y: -2)
                    
                    Spacer()
                    
                    // Right: Numbers
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(String(format: NSLocalizedString("surah_header_no", comment: ""), surah.number).uppercased())
                        Text(String(format: NSLocalizedString("surah_header_order", comment: ""), surah.revelationOrder ?? 0).uppercased())
                    }
                    .font(.system(size: 7, weight: .black))
                    .foregroundColor(colors.primary.opacity(0.7))
                    .frame(width: 70, alignment: .trailing)
                }
                .padding(.horizontal, 20)
                
                // Bottom: Transliteration & Translation
                HStack(spacing: 6) {
                    Text(surah.nameComplex)
                        .font(.system(size: 11, weight: .bold, design: .serif))
                    Text("•")
                        .foregroundColor(colors.primary.opacity(0.4))
                    Text(surah.nameTranslation)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(colors.foreground.opacity(0.5))
                }
                .foregroundColor(colors.primary)
            }
            .padding(.vertical, 8)
        }
        .frame(height: 66)
        .padding(.vertical, 2)
    }
    
    private var cornerOrnaments: some View {
        ZStack {
            ForEach(0..<4) { i in
                VStack {
                    if i < 2 { Spacer() }
                    HStack {
                        if i % 2 == 1 { Spacer() }
                            Circle()
                            .fill(colors.primary.opacity(0.2))
                            .frame(width: 3, height: 3)
                            .padding(6)
                        if i % 2 == 0 { Spacer() }
                    }
                    if i >= 2 { Spacer() }
                }
            }
            
            // Decorative lines
            VStack {
                Rectangle().fill(colors.primary.opacity(0.08)).frame(height: 0.5)
                Spacer()
                Rectangle().fill(colors.primary.opacity(0.08)).frame(height: 0.5)
            }
            .padding(10)
        }
    }
}
