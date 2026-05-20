//
//  DuaRow.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DuaRow: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: DuaEntity
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with category tag
            HStack {
                Text(item.category.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(colors.primary.opacity(0.1))
                    .clipShape(Capsule())
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colors.secondary.opacity(0.3))
            }
            
            // Title and description
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text(item.translation)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .hiraCleanCard(colors: colors)
        .padding(.horizontal, 4) // Subtle breathing room
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
    }
}

#Preview {
    VStack(spacing: 16) {
        DuaRow(item: DuaEntity(
            id: 1,
            category: "morning",
            title: "Morning Remembrance",
            arabic: "...",
            transliteration: "...",
            translation: "We have reached the morning...",
            source: "Abu Dawud",
            repeatOnce: 1
        ))
    }
    .padding()
}

