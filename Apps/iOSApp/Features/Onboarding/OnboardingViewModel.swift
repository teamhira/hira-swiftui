//
//  OnboardingViewModel.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation

public struct OnboardingContent: Identifiable {
    public let id = UUID()
    public let titleKey: String
    public let subtitleKey: String
    public let systemImage: String
    public let accessibilityTitleKey: String
    public let accessibilitySubtitleKey: String
    public let accessibilityImageKey: String
    
    public func title(language: LanguageManager) -> String {
        language.localizedString(titleKey)
    }
    
    public func subtitle(language: LanguageManager) -> String {
        language.localizedString(subtitleKey)
    }
    
    public func accessibilityTitle(language: LanguageManager) -> String {
        language.localizedString(accessibilityTitleKey)
    }
    
    public func accessibilitySubtitle(language: LanguageManager) -> String {
        language.localizedString(accessibilitySubtitleKey)
    }
    
    public func accessibilityImage(language: LanguageManager) -> String {
        language.localizedString(accessibilityImageKey)
    }
}

@Observable
public class OnboardingViewModel: BaseViewModel {
    private let userDefaultsService: UserDefaultsService
    
    // MARK: - State
    public var currentPage: Int = 0 
    public var showFeaturePages: Bool = false
    
    // Landing (Page 1)
    public var landingPage: OnboardingContent {
        OnboardingContent(
            titleKey: "onboarding_landing_title",
            subtitleKey: "onboarding_landing_subtitle",
            systemImage: "leaf.fill",
            accessibilityTitleKey: "onboarding_landing_title",
            accessibilitySubtitleKey: "onboarding_landing_subtitle",
            accessibilityImageKey: "onboarding_accessibility_image_hira"
        )
    }
    
    // Features (Page 2-5)
    public var featurePages: [OnboardingContent] {
        [
            OnboardingContent(
                titleKey: "onboarding_quran_title",
                subtitleKey: "onboarding_quran_subtitle",
                systemImage: "book.pages.fill",
                accessibilityTitleKey: "onboarding_quran_title",
                accessibilitySubtitleKey: "onboarding_quran_subtitle",
                accessibilityImageKey: "onboarding_accessibility_image_quran"
            ),
            OnboardingContent(
                titleKey: "onboarding_prayer_title",
                subtitleKey: "onboarding_prayer_subtitle",
                systemImage: "mosque.fill",
                accessibilityTitleKey: "onboarding_prayer_title",
                accessibilitySubtitleKey: "onboarding_prayer_subtitle",
                accessibilityImageKey: "onboarding_accessibility_image_prayer"
            ),
            OnboardingContent(
                titleKey: "onboarding_inspiration_title",
                subtitleKey: "onboarding_inspiration_subtitle",
                systemImage: "sparkles",
                accessibilityTitleKey: "onboarding_inspiration_title",
                accessibilitySubtitleKey: "onboarding_inspiration_subtitle",
                accessibilityImageKey: "onboarding_accessibility_image_inspiration"
            ),
            OnboardingContent(
                titleKey: "onboarding_final_title",
                subtitleKey: "onboarding_final_subtitle",
                systemImage: "sun.max.fill",
                accessibilityTitleKey: "onboarding_final_title",
                accessibilitySubtitleKey: "onboarding_final_subtitle",
                accessibilityImageKey: "onboarding_accessibility_image_final"
            )
        ]
    }
    
    public init(userDefaultsService: UserDefaultsService = DIContainer.shared.userDefaultsService) {
        self.userDefaultsService = userDefaultsService
        super.init()
    }
    
    public func startFeatures() {
        withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.85)) {
            showFeaturePages = true
        }
    }
    
    public func completeOnboarding() {
        userDefaultsService.set(true, forKey: "hasCompletedOnboarding")
    }
    
    public func nextFeaturePage() {
        if currentPage < featurePages.count - 1 {
            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.82)) {
                currentPage += 1
            }
        }
    }
    
    public func previousFeaturePage() {
        if currentPage > 0 {
            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.82)) {
                currentPage -= 1
            }
        }
    }
}