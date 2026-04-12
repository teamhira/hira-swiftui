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
    
    // Animation States
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    @State private var bgScale: CGFloat = 1.0
    @State private var animateMesh = false
    @State private var isExiting = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // MARK: - Dynamic Background
            ZStack {
                colors.background.ignoresSafeArea()
                
                // Animated Mesh Blobs
                Group {
                    Circle()
                        .fill(colors.primary.opacity(0.35))
                        .frame(width: 450)
                        .blur(radius: 80)
                        .offset(x: animateMesh ? -120 : 120, y: animateMesh ? -180 : 180)
                    
                    Circle()
                        .fill(colors.secondary.opacity(0.25))
                        .frame(width: 400)
                        .blur(radius: 70)
                        .offset(x: animateMesh ? 180 : -180, y: animateMesh ? 220 : -220)
                }
                .scaleEffect(bgScale)
            }
            .ignoresSafeArea()
            
            // MARK: - Main Content
            VStack(spacing: 32) {
                Spacer()
                
                // Logo Section with Twitter-style transition capability
                ZStack {
                    // Outer Glow
                    Circle()
                        .fill(colors.primary.opacity(0.15))
                        .frame(width: 220, height: 220)
                        .blur(radius: isExiting ? 0 : 40)
                        .scaleEffect(isExiting ? 4 : 1)
                    
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .shadow(color: colors.primary.opacity(0.2), radius: 20, x: 0, y: 10)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // Text & Loading Section
                VStack(spacing: 16) {
                    Text(appEnv.language.localizedString("onboarding_landing_title"))
                        .font(TextStyle.display)
                        .foregroundColor(colors.foreground)
                        .tracking(4)
                    
                    ProgressView()
                        .tint(colors.primary)
                        .scaleEffect(1.2)
                        .opacity(isExiting ? 0 : 1)
                }
                .opacity(contentOpacity)
                .offset(y: isExiting ? 40 : 0)
                
                Spacer()
                
                // Version or Tagline
                Text("V 1.0")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(colors.foreground.opacity(0.3))
                    .opacity(contentOpacity)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            startEntranceAnimation()
        }
    }
    
    // MARK: - Animations
    
    private func startEntranceAnimation() {
        // 1. Entrance: Logo & Content fade in
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            contentOpacity = 1.0
        }
        
        // 2. Background Mesh animation
        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
            animateMesh.toggle()
        }
        
        // 3. Trigger Startup Checks & Exit
        performStartupChecks()
    }
    
    private func performStartupChecks() {
        // Multi-check (Auth, Internet, etc.)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            executeTwitterExitAnimation()
        }
    }
    
    private func executeTwitterExitAnimation() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        // Twitter-style Zoom:
        // Step 1: Shrink slightly (Anticipation)
        withAnimation(.easeOut(duration: 0.2)) {
            logoScale = 0.9
            isExiting = true
        }
        
        // Step 2: Zoom in massive & fade out
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
                logoScale = 25.0 // Zoom to infinity
                logoOpacity = 0
                bgScale = 1.5
                contentOpacity = 0
            }
            
            // Final Transition to Next Screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    appState.showSplash = false
                }
                
                if !hasCompletedOnboarding {
                    router.navigate(to: .onboarding)
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environment(AppRouter())
        .environment(AppState())
}