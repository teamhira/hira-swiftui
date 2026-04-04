//
//  ThemeSettingView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct ThemeSettingView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let themes: [ThemeVariant] = ThemeVariant.allCases
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - 1. Live Interactive Preview
                    VStack(alignment: .leading, spacing: 16) {
                        Text(appEnv.language.localizedString("profile_appearance_preview"))
                            .font(.caption.bold())
                            .foregroundColor(colors.foreground.opacity(0.4))
                            .kerning(1)
                        
                        ThemePreviewCard()
                            .shadow(color: colors.primary.opacity(0.1), radius: 20, x: 0, y: 10)
                    }
                    .padding(.top, 24)
                    
                    // MARK: - 2. Selection Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("profile_appearance_character"))
                            .font(.caption.bold())
                            .foregroundColor(colors.foreground.opacity(0.4))
                            .kerning(1)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(themes, id: \.self) { variant in
                                ThemeSelectionCard(variant: variant, isSelected: appEnv.theme.variant == variant) {
                                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7)) {
                                        appEnv.theme.setTheme(variant)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(appEnv.language.localizedString("profile_appearance_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Interactive Preview Component
private struct ThemePreviewCard: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Circle().fill(colors.primary).frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 4).fill(colors.foreground.opacity(0.1)).frame(width: 80, height: 8)
                    RoundedRectangle(cornerRadius: 4).fill(colors.foreground.opacity(0.05)).frame(width: 120, height: 6)
                }
                Spacer()
            }
            Divider().opacity(0.1)
            HStack {
                Text(appEnv.language.localizedString("profile_appearance_sample")).font(.caption.bold()).foregroundColor(colors.foreground)
                Spacer()
                RoundedRectangle(cornerRadius: 8).fill(colors.primary.opacity(0.1)).frame(width: 50, height: 26)
            }
        }
        .padding(AppSpacing.lg)
        .hiraCleanCard(colors: colors, radius: 24)
    }
}

// MARK: - Stylized Selection Card
private struct ThemeSelectionCard: View {
    let variant: ThemeVariant
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                let base = ThemeFactory.baseColorsFor(variant: variant)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(base.primary.opacity(0.15))
                        .frame(height: 100)
                    
                    // Stylized Dot Pattern
                    Circle().fill(base.primary).frame(width: 36, height: 36)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                
                Text(variant.displayName)
                    .font(.caption.bold())
                    .foregroundColor(colors.foreground)
            }
            .padding(AppSpacing.sm + 2)
            .hiraCleanCard(colors: colors, radius: 32)
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isSelected ? colors.primary : Color.clear, lineWidth: 2)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
}

#Preview {
    NavigationStack {
        ThemeSettingView()
    }
}
