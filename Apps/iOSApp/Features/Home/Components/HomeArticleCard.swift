//
//  HomeArticleCard.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct HomeArticleCard: View {
    let colors: ThemeModel
    let image: String
    let title: String
    let date: String
    let description: String
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: 16) {
            // Sample Image Placeholder with Theme Background
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 90, height: 90)
                
                Image(systemName: "photo")
                    .foregroundColor(colors.primary.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(date)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.primary)
                
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(AppSpacing.sm + 4)
        .hiraCleanCard(colors: colors, radius: 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("home_accessibility_article_card"), title))
        .accessibilityHint(description)
    }
}
