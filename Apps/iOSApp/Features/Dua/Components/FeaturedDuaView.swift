//
//  FeaturedDuaView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct FeaturedDuaView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let title: String
    let description: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    // Feature Tag
                    Text(appEnv.language.localizedString("dua_featured_tag"))
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Text(LocalizedStringKey(title))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(colors.primary)
                    .padding(.top, 4)
            }
            
            Text(LocalizedStringKey(description))
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(colors.primary.opacity(0.05))
        )
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStringKey(title))
        .accessibilityHint(LocalizedStringKey(description))
    }
}

#Preview {
    FeaturedDuaView(
        title: "dua_featured_title",
        description: "dua_featured_desc"
    )
}
