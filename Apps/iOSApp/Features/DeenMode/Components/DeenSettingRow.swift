//
//  DeenSettingRow.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct DeenSettingRow: View {
    let setting: DeenSetting
    let colors: ThemeModel
    let onToggle: () -> Void
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(setting.isActive ? colors.primary.opacity(0.1) : colors.foreground.opacity(0.05))
                    .frame(width: 44, height: 44)
                
                Image(systemName: setting.icon)
                    .font(.system(size: 18))
                    .foregroundColor(setting.isActive ? colors.primary : colors.foreground.opacity(0.4))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(appEnv.language.localizedString(setting.titleKey))
                    .font(TextStyle.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString(setting.descKey))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { setting.isActive },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(colors.primary)
        }
        .padding(AppSpacing.md)
        .background(colors.card)
        .cornerRadius(16)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }
}
