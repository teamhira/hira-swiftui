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
                VStack {
                    OnboardingHeaderView(
                        currentPage: viewModel.currentPage,
                        totalPages: viewModel.featurePages.count,
                        onBack: viewModel.previousFeaturePage,
                        onSkip: completeWithSlideDown
                    )
                    
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.featurePages.count, id: \.self) { index in
                            OnboardingPageView(page: viewModel.featurePages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8), value: viewModel.currentPage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
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
                .offset(y: isExiting ? 1000 : 0)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.85), value: isExiting)
            }
            
            // MARK: - Layer 1: Landing Page
            if !viewModel.showFeaturePages {
                VStack {
                    Spacer().frame(height: 50)
                    
                    OnboardingPageView(page: viewModel.landingPage)
                    
                    OnboardingFooterView(
                        currentPage: 0,
                        totalPages: 1,
                        isLanding: true,
                        onNext: {},
                        onGetStarted: viewModel.startFeatures,
                        onLogin: {} // No login on landing
                    )
                }
                .transition(.asymmetric(
                    insertion: .identity,
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                appear = true
            }
        }
    }
    
    // Complete flow & navigate to Home
    private func completeWithSlideDown() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
            isExiting = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            viewModel.completeOnboarding()
            router.popToRoot()
        }
    }
    
    // Auth flow & navigate to Login
    private func navigateToLogin() {
        router.navigate(to: .login)
    }
}

// MARK: - Simplified Morphing Background
struct MorphingBackgroundView: View {
    let currentPage: Int
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background
            
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(colors.primary.opacity(0.12))
                        .frame(width: 450, height: 450)
                        .offset(x: currentPage % 2 == 0 ? -120 : 120, y: -200)
                    
                    Circle()
                        .fill(colors.primary.opacity(0.1))
                        .frame(width: 320, height: 320)
                        .offset(x: currentPage % 2 == 0 ? 120 : -120, y: 350)
                }
                .blur(radius: 70)
                .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.9), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AppRouter())
}
