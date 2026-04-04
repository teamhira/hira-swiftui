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
            Spacer(minLength: 40)
            
            // MARK: - Refined Illustration (Balanced Scale)
            ZStack {
                // Background Glow
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [colors.primary.opacity(0.12), colors.primary.opacity(0.01)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 230, height: 230)
                    .scaleEffect(animateItems ? 1.0 : 0.6)
                    .blur(radius: animateItems ? 0 : 20)
                
                // Decorative Rings (Subtle)
                Circle()
                    .stroke(colors.primary.opacity(0.08), lineWidth: 1)
                    .frame(width: 250, height: 250)
                    .scaleEffect(animateItems ? 1.0 : 0.8)
                
                Image(systemName: page.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(colors.primary)
                    .offset(y: floatingOffset)
                    .scaleEffect(animateItems ? 1.0 : 0.8)
                    .shadow(color: colors.primary.opacity(0.15), radius: 10, y: 8)
                    .accessibilityLabel(page.accessibilityImage(language: appEnv.language))
            }
            .padding(.bottom, 60)
            
            // MARK: - Elegant & Balanced Typography
            VStack(spacing: AppSpacing.md) {
                Text(page.title(language: appEnv.language))
                    .font(TextStyle.display) 
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
                    .opacity(animateItems ? 1 : 0)
                    .offset(y: animateItems ? 0 : 15)
                    .tracking(0.5)
                
                Text(page.subtitle(language: appEnv.language))
                    .font(TextStyle.body)
                    .foregroundColor(colors.foreground.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 44)
                    .opacity(animateItems ? 0.9 : 0)
                    .offset(y: animateItems ? 0 : 20)
                    .lineSpacing(3)
            }
            
            Spacer(minLength: 120) 
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateItems = true
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatingOffset = -12
            }
        }
        .onDisappear {
            animateItems = false
        }
    }
}

#Preview {
    OnboardingPageView(
        page: OnboardingContent(
             titleKey: "onboarding_quran_title",
             subtitleKey: "onboarding_quran_subtitle",
             systemImage: "book.pages.fill",
             accessibilityTitleKey: "onboarding_quran_title",
             accessibilitySubtitleKey: "onboarding_quran_subtitle",
             accessibilityImageKey: "onboarding_accessibility_image_quran"
        )
    )
}
