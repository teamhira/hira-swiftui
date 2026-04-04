//
//  OnboardingHeaderView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct OnboardingHeaderView: View {
    let currentPage: Int
    let totalPages: Int
    let onBack: () -> Void
    let onSkip: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack {
            // MARK: - Back Button (Localized)
            if currentPage > 0 {
                Button(action: onBack) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "arrow.left")
                            .accessibilityHidden(true)
                        Text(appEnv.language.localizedString("onboarding_button_back"))
                    }
                    .font(TextStyle.subheadline.bold())
                    .foregroundColor(colors.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .accessibilityLabel(appEnv.language.localizedString("onboarding_button_back"))
            } else {
                Spacer().frame(width: 80)
            }
            
            Spacer()
            
            // MARK: - Skip Button (Localized)
            if currentPage < totalPages - 1 {
                Button(action: onSkip) {
                    Text(appEnv.language.localizedString("onboarding_button_skip"))
                        .font(TextStyle.subheadline.bold())
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(colors.primary.opacity(0.05))
                        )
                        .overlay(
                            Capsule()
                                .stroke(colors.primary.opacity(0.12), lineWidth: 1)
                        )
                }
                .accessibilityLabel(appEnv.language.localizedString("onboarding_accessibility_button_skip"))
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
    }
}

#Preview {
    OnboardingHeaderView(
        currentPage: 1,
        totalPages: 4,
        onBack: {},
        onSkip: {}
    )
}
