//
//  OnboardingView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct OnboardingView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = OnboardingViewModel()
    @State private var isExiting = false
    @State private var appear = false
    
    private var theme: ThemeManager { appEnv.theme }
    private var colors: ThemeModel { theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // MARK: - Morphing Background
            MorphingBackgroundView(currentPage: viewModel.showFeaturePages ? (viewModel.currentPage + 1) : 0)
                .ignoresSafeArea()
            
            // MARK: - Layer 2: Feature Pages
            if viewModel.showFeaturePages {
                VStack(spacing: 0) {
                    // Custom Header removed to use .toolbar instead
                    
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.featurePages.count, id: \.self) { index in
                            OnboardingPageView(page: viewModel.featurePages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8), value: viewModel.currentPage)
                    
                    OnboardingFooterView(
                        currentPage: viewModel.currentPage,
                        totalPages: viewModel.featurePages.count,
                        isLanding: false,
                        onNext: viewModel.nextFeaturePage,
                        onGetStarted: completeWithSlideDown,
                        onLogin: navigateToLogin
                    )
                }
                .blur(radius: isExiting ? 20 : 0)
                .offset(y: isExiting ? 100 : 0)
                .opacity(isExiting ? 0 : 1)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
            
            // MARK: - Layer 1: Landing Page
            if !viewModel.showFeaturePages {
                VStack(spacing: 0) {
                    Spacer().frame(height: 40)
                    
                    OnboardingPageView(page: viewModel.landingPage)
                    
                    OnboardingFooterView(
                        currentPage: 0,
                        totalPages: 1,
                        isLanding: true,
                        onNext: {},
                        onGetStarted: viewModel.startFeatures,
                        onLogin: {}
                    )
                }
                .transition(.asymmetric(
                    insertion: .identity,
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if viewModel.showFeaturePages {
                // Leading: Back Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Group {
                        if viewModel.currentPage > 0 {
                            Button(action: viewModel.previousFeaturePage) {
                                HStack(spacing: AppSpacing.xs) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .bold))
                                    Text(appEnv.language.localizedString("onboarding_button_back"))
                                }
                                .font(TextStyle.subheadline.bold())
                                .foregroundColor(colors.primary)
                            }
                        }
                    }
                    .animation(.spring(), value: viewModel.currentPage)
                }
                
                // Trailing: Skip Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Group {
                        if viewModel.currentPage < viewModel.featurePages.count - 1 {
                            Button(action: skipToLastPage) {
                                Text(appEnv.language.localizedString("onboarding_button_skip"))
                                    .font(TextStyle.subheadline.bold())
                                    .foregroundColor(colors.primary)
                            }
                        }
                    }
                    .animation(.spring(), value: viewModel.currentPage)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                appear = true
            }
        }
    }
    
    // Jump to last page
    private func skipToLastPage() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8)) {
            viewModel.currentPage = viewModel.featurePages.count - 1
        }
    }
    
    // Complete flow & navigate to Home
    private func completeWithSlideDown() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
            isExiting = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.completeOnboarding()
            router.popToRoot()
        }
    }
    
    // Auth flow & navigate to Login
    private func navigateToLogin() {
        router.navigate(to: .login)
    }
}

// MARK: - Cohesive Morphing Background
struct MorphingBackgroundView: View {
    let currentPage: Int
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var animateExtra = false
    
    var body: some View {
        ZStack {
            colors.background
            
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(colors.primary.opacity(0.12))
                        .frame(width: 450, height: 450)
                        .blur(radius: 80)
                        .offset(x: currentPage % 2 == 0 ? -120 : 120, y: animateExtra ? -180 : -220)
                    
                    Circle()
                        .fill(colors.secondary.opacity(0.1))
                        .frame(width: 320, height: 320)
                        .blur(radius: 70)
                        .offset(x: currentPage % 2 == 0 ? 120 : -120, y: animateExtra ? 320 : 380)
                }
                .animation(.interactiveSpring(response: 1.5, dampingFraction: 0.85), value: currentPage)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animateExtra)
            }
        }
        .onAppear {
            animateExtra = true
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
            .environment(AppRouter())
            .environment(AppState())
    }
}
