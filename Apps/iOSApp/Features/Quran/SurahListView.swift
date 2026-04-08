//
//  SurahListView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahListView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        List(Surah.previewList) { surah in
            NavigationLink(value: AppRoute.surahDetail(surah)) {
                HStack(spacing: 16) {
                    Text("\(surah.number)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(colors.primary)
                        .frame(width: 36, height: 36)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(surah.name)
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        Text(appEnv.language.localizedString("quran_ayah_count_label", arguments: [surah.versesCount, surah.versesCount]))
                            .font(.caption)
                            .foregroundColor(colors.foreground.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    Text(surah.nameArabic)
                        .font(.title3.bold())
                        .foregroundColor(colors.primary)
                }
                .padding(.vertical, 4)
            }
            .listRowBackground(colors.background)
            .listRowSeparatorTint(colors.foreground.opacity(0.1))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(appEnv.language.localizedString("quran_accessibility_surah_card", arguments: [surah.name, surah.number, surah.versesCount]))
            .accessibilityHint(appEnv.language.localizedString("quran_accessibility_surah_hint"))
        }
        .listStyle(.plain)
        .background(colors.background)
    }
}

#Preview {
    NavigationStack {
        SurahListView()
    }
}
