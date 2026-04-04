//
//  CategoryGridItem.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct CategoryGridItem: View {
    let category: ExploreCategory
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(colors.primary)
                .frame(width: 52, height: 52)
                .background(Circle().fill(colors.primary.opacity(0.1)))
            
            VStack(spacing: 4) {
                Text(appEnv.language.localizedString(category.titleKey))
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString(category.descKey))
                    .font(.caption2)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
        .hiraCleanCard(colors: colors)
    }
}
