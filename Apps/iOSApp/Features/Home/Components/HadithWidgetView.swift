//
//  HadithWidgetView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct HadithWidgetView: View {
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.title3)
                    .foregroundColor(colors.primary)
                Text(appEnv.language.localizedString("home_hadith_title"))
                    .font(.caption.bold())
                    .foregroundColor(colors.primary)
                    .kerning(1)
            }
            
            Text(appEnv.language.localizedString("home_hadith_sample"))
                .font(.system(size: 16, weight: .medium, design: .serif))
                .italic()
                .foregroundColor(colors.foreground)
                .lineSpacing(4)
            
            HStack {
                Spacer()
                Text("— \(appEnv.language.localizedString("home_hadith_source"))")
                    .font(.caption.bold())
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
        }
        .padding(AppSpacing.lg)
        .hiraCleanCard(colors: colors)
        .padding(.horizontal, AppSpacing.lg)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("home_accessibility_hadith_card"))
        .accessibilityHint(appEnv.language.localizedString("home_hadith_title"))
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        HadithWidgetView(colors: ThemeFactory.make(.green, isDark: false))
    }
}
