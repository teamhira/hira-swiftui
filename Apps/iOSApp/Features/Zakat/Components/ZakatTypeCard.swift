//
//  ZakatTypeCard.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Component representing a clickable card for choosing a Zakat type.
public struct ZakatTypeCard: View {
    let type: ZakatType
    let colors: ThemeModel
    
    public init(type: ZakatType, colors: ThemeModel) {
        self.type = type
        self.colors = colors
    }
    
    @Environment(\.appEnvironment) var appEnv
    
    public var body: some View {
        
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(colors.foreground.opacity(0.05))
                    .frame(width: 54, height: 54)
                
                Image(systemName: type.icon)
                    .font(.title3)
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appEnv.language.localizedString(type.localizedTitleKey))
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString(type.localizedDescKey))
                    .font(.caption2)
                    .foregroundColor(colors.foreground.opacity(0.4))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2.bold())
                .foregroundColor(colors.foreground.opacity(0.15))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colors.background)
        )
        .hiraCleanCard(colors: colors, radius: 20)
        .cornerRadius(20)
    }
}
