//
//  HadithCollectionCard.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HadithCollectionCard: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let collection: HadithCollectionEntity
    let icon: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Icon Container
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appEnv.language.localizedString("hadith_col_\(collection.key)", fallback: collection.name))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text("\(collection.totalHadiths) \(Text(appEnv.language.localizedString("hadith_explore_btn")).font(.system(size: 10)))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colors.background)
                .overlay(
                    LinearGradient(
                        colors: [colors.primary.opacity(0.03), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(collection.name)
        .accessibilityHint(appEnv.language.localizedString("hadith_accessibility_col_item"))
    }
}
