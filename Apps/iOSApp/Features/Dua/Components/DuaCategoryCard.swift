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
    
    let category: DuaCategoryEntity
    let icon: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon Background
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text("\(category.count ?? 0) \(Text("duas"))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colors.background)
        )
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(category.name)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        DuaCategoryCard(
            category: DuaCategoryEntity(id: "morning", name: "Morning Adhkar", description: "Desc", count: 12),
            icon: "sun.max"
        )
    }
    .padding()
}

