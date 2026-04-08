//
//  DuaCategoryCard.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DuaCategoryCard: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let category: String
    let icon: String?
    let count: Int
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon Background
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(colors.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(category))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text("\(count) \(Text("duas"))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colors.background)
                .overlay(
                    LinearGradient(
                        colors: [colors.primary.opacity(0.05), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStringKey("dua_accessibility_category_item"))
        .accessibilityHint(LocalizedStringKey(category))
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        DuaCategoryCard(category: "dua_category_all", icon: "square.grid.2x2", count: 12)
        DuaCategoryCard(category: "dua_category_daily", icon: "sun.max", count: 8)
    }
    .padding()
}
