//
//  SurahCardView.swift
//  Hira
//

import SwiftUI

public struct SurahCardView: View {
    let surah: Surah
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        let colors = appEnv.theme.current
        HStack(spacing: 16) {
            // Surah Number in Circle matching feature icon style
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                Text("\(surah.number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            // Surah Name & Translation
            VStack(alignment: .leading, spacing: 4) {
                Text(surah.name)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                Text(surah.nameTranslation)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
            
            Spacer()
            
            // Arabic Name & Verse Count
            VStack(alignment: .trailing, spacing: 4) {
                Text(surah.nameArabic)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colors.primary)
                Text(appEnv.language.localizedString("quran_verses_count", arguments: [surah.versesCount]))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
        }
        .padding(AppSpacing.md)
        .hiraCleanCard(colors: colors, radius: 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("quran_accessibility_surah_card", arguments: [surah.name, surah.number, surah.versesCount]))
    }
}
