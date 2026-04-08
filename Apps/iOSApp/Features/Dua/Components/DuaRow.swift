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
    
    let title: String
    let description: String
    let category: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with category tag
            HStack {
                Text(LocalizedStringKey(category))
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
                Text(LocalizedStringKey(title))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text(LocalizedStringKey(description))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStringKey(title))
        .accessibilityHint(LocalizedStringKey("dua_accessibility_item"))
    }
}

#Preview {
    VStack(spacing: 16) {
        DuaRow(
            title: "Protection from harm",
            description: "Dua recited every morning and evening for safety.",
            category: "Morning & Evening"
        )
        DuaRow(
            title: "Entering home",
            description: "To seek blessings when returning home.",
            category: "Daily Life"
        )
    }
    .padding()
}
