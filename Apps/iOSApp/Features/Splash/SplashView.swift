//
//  SplashView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SplashView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState
    
    @Environment(\.appEnvironment) private var appEnv
    @State private var animateBlob = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // MARK: - Animated Mesh Background
            ZStack {
                colors.background.ignoresSafeArea()
                
                // Animated Blobs for Mesh Effect
                Circle()
                    .fill(colors.primary.opacity(0.4))
                    .frame(width: 400)
                    .blur(radius: 80)
                    .offset(x: animateBlob ? -100 : 100, y: animateBlob ? -150 : 150)
                
                Circle()
                    .fill(colors.secondary.opacity(0.3))
                    .frame(width: 350)
                    .blur(radius: 70)
                    .offset(x: animateBlob ? 150 : -150, y: animateBlob ? 200 : -200)
                
                Circle()
                    .fill(colors.accent.opacity(0.2))
                    .frame(width: 300)
                    .blur(radius: 60)
                    .offset(x: animateBlob ? 50 : -50, y: animateBlob ? -100 : 100)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    animateBlob.toggle()
                }
            }
            
            VStack(spacing: 24) {
                // Logo with subtle glow
                ZStack {
                    colors.primary.opacity(0.1)
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                    
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel(appEnv.language.localizedString("login_logo_accessibility"))
                
                Text(appEnv.language.localizedString("onboarding_landing_title"))
                    .font(TextStyle.display)
                    .foregroundColor(colors.foreground)
                    .tracking(2)
                
                ProgressView()
                    .tint(colors.primary)
                    .scaleEffect(1.2)
                    .padding(.top, 40)
            }
        }

        .onAppear {
            performStartupChecks()
        }
    }
    
    private func performStartupChecks() {
        // Multi-check: Auth, Internet, etc.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
            
            withAnimation(.easeInOut(duration: 0.6)) {
                appState.showSplash = false
            }
            
            if !hasCompletedOnboarding {
                router.navigate(to: .onboarding)
            }
        }
    }
}

#Preview {
    SplashView()
        .environment(AppRouter())
}