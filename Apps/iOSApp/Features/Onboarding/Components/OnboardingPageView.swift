//
//  OnboardingPageView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct OnboardingPageView: View {
    let page: OnboardingContent
    
    @State private var animateItems = false
    @State private var floatingOffset: CGFloat = 0
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 20)
            
            // MARK: - Refined Illustration
            ZStack {
                // Background Glow
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 350)
                    .blur(radius: 50)
                    .scaleEffect(animateItems ? 1.0 : 0.6)
                
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                    .offset(y: floatingOffset)
                    .scaleEffect(animateItems ? 1.0 : 0.8)
                    .shadow(color: colors.primary.opacity(0.15), radius: 30, x: 0, y: 20)
            }
            .accessibilityLabel(page.accessibilityImage(language: appEnv.language))
            .padding(.bottom, 40)
            
            // MARK: - Elegant Typography
            VStack(spacing: AppSpacing.md) {
                Text(page.title(language: appEnv.language))
                    .font(TextStyle.display) 
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
                    .opacity(animateItems ? 1 : 0)
                    .offset(y: animateItems ? 0 : 20)
                    .tracking(0.5)
                
                Text(page.subtitle(language: appEnv.language))
                    .font(TextStyle.body)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 40)
                    .opacity(animateItems ? 1 : 0)
                    .offset(y: animateItems ? 0 : 20)
                    .lineSpacing(4)
            }
            
            Spacer(minLength: 80) 
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                animateItems = true
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatingOffset = -15
            }
        }
    }
}

#Preview {
    OnboardingPageView(
        page: OnboardingContent(
             titleKey: "onboarding_quran_title",
             subtitleKey: "onboarding_quran_subtitle",
             imageName: "OnboardingQuran",
             accessibilityTitleKey: "onboarding_quran_title",
             accessibilitySubtitleKey: "onboarding_quran_subtitle",
             accessibilityImageKey: "onboarding_accessibility_image_quran"
        )
    )
}
