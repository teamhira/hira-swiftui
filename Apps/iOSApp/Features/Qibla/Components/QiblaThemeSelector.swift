//
//  QiblaThemeSelector.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct QiblaThemeSelector: View {
    @Environment(\.appEnvironment) private var appEnv
    @Binding var selectedStyle: QiblaCompassStyle
    let onSelect: () -> Void
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appEnv.language.localizedString("qibla_compass_themes_title", defaultValue: "Compass Themes"))
                .font(.subheadline.bold())
                .foregroundColor(colors.foreground)
                .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(QiblaCompassStyle.availableStyles) { style in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedStyle = style
                                onSelect()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(colors.foreground.opacity(0.05))
                                    .frame(width: 52, height: 52)
                                    .overlay(
                                        Circle()
                                            .stroke(style == selectedStyle ? style.color : Color.clear, lineWidth: 2)
                                    )
                                
                                Image(systemName: "safari.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(style.color)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(appEnv.language.localizedString("qibla_theme_label", defaultValue: "Theme")): \(style.name)")
                        .accessibilityHint(appEnv.language.localizedString("qibla_theme_hint", defaultValue: "Double tap to select this compass theme"))
                        .accessibilityAddTraits(style == selectedStyle ? .isSelected : [])
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }
        }
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.md)
        .hiraCleanCard(colors: colors, radius: 32)
        .padding(.horizontal, AppSpacing.md)
        .padding(.bottom, AppSpacing.lg - 4)
    }
}
