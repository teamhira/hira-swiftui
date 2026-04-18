//
//  OnboardingFooterView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct OnboardingFooterView: View {
    let currentPage: Int
    let totalPages: Int
    let isLanding: Bool
    let onNext: () -> Void
    let onGetStarted: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Localized Labels
    private var buttonLabel: String {
        if isLanding {
            return appEnv.language.localizedString("onboarding_button_get_started")
        } else if currentPage == totalPages - 1 {
            return appEnv.language.localizedString("onboarding_button_start")
        } else {
            return appEnv.language.localizedString("onboarding_button_next")
        }
    }
    
    public var body: some View {
        VStack(spacing: AppSpacing.xl) {
            // MARK: - Page Indicator
            if !isLanding {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? colors.primary : colors.primary.opacity(0.15))
                            .frame(width: index == currentPage ? 28 : 8, height: 8)
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                .transition(.opacity)
            }
            
            // MARK: - Action Button
            Button(action: {
                if isLanding {
                    onGetStarted()
                } else if currentPage == totalPages - 1 {
                    onGetStarted()
                } else {
                    onNext()
                }
            }) {
                HStack(spacing: AppSpacing.sm) {
                    Text(buttonLabel)
                        .font(TextStyle.headline.bold())
                    
                    if !isLanding && currentPage < totalPages - 1 {
                         Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .accessibilityHidden(true)
                    }
                }
                .foregroundColor(colors.primaryForeground)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Capsule().fill(colors.primary))
                .shadow(color: colors.primary.opacity(0.3), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 40)
            }
            .accessibilityLabel(
                isLanding ? appEnv.language.localizedString("onboarding_button_get_started") : 
                (currentPage == totalPages - 1 ? appEnv.language.localizedString("onboarding_button_start") : appEnv.language.localizedString("onboarding_accessibility_button_next"))
            )
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8), value: currentPage)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    OnboardingFooterView(
        currentPage: 2,
        totalPages: 4,
        isLanding: false,
        onNext: {},
        onGetStarted: {},
    )
}
