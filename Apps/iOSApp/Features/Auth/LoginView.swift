//
//  LoginView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct LoginView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var animateItems = false
    @State private var isLoggingIn = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            BackgroundVisuals(animate: $animateItems)
            
            VStack(spacing: 0) {
                Spacer() // Pushes content towards center from top
                
                VStack(spacing: 48) {
                    // MARK: - 1. Premium Header
                    LoginHeader()
                        .opacity(isLoggingIn ? 0.5 : 1)
                        .blur(radius: isLoggingIn ? 2 : 0)
                    
                    VStack(spacing: AppSpacing.xl) {
                        // MARK: - 2. Principal Login Method
                        QFLoginButton(isLoading: isLoggingIn, action: loginWithQuranFoundation)
                        
                        // MARK: - 3. Auxiliary Actions
                        Button(action: {
                            if let url = URL(string: "https://quran.com/forgot-password") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(appEnv.language.localizedString("login_button_forgot_password"))
                                .font(TextStyle.footnote.bold())
                                .foregroundColor(colors.primary)
                                .padding(.top, 8)
                        }
                        .accessibilityLabel(appEnv.language.localizedString("login_accessibility_forgot_password"))
                        .disabled(isLoggingIn)
                        .opacity(isLoggingIn ? 0.3 : 1)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                }
                
                Spacer() // Pushes content towards center from bottom
                
                // MARK: - 4. Support Footer
                LoginFooter()
                    .padding(.bottom, 30)
                    .disabled(isLoggingIn)
                    .opacity(isLoggingIn ? 0.3 : 1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) { animateItems = true }
        }
    }
    
    private func loginWithQuranFoundation() {
        guard !isLoggingIn else { return }
        
        withAnimation(.easeInOut) { isLoggingIn = true }
        
        Task {
            do {
                let userInfo = try await appEnv.di.oauthService.login(platform: "ios")
                await MainActor.run {
                    appState.currentUser = userInfo
                    appState.isLoggedIn = true
                    router.popToRoot()
                    isLoggingIn = false
                }
            } catch {
                print("❌ Login failed: \(error)")
                await MainActor.run {
                    withAnimation { isLoggingIn = false }
                }
            }
        }
    }
}

// MARK: - Subcomponents

private struct BackgroundVisuals: View {
    @Binding var animate: Bool
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            Circle()
                .fill(colors.primary.opacity(0.12))
                .frame(width: 400)
                .blur(radius: 100)
                .offset(x: animate ? -100 : 100, y: -250)
        }
        .accessibilityHidden(true)
        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
    }
}

private struct LoginHeader: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 28) {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
                .shadow(color: colors.primary.opacity(0.15), radius: 15, y: 8)
                .accessibilityLabel(appEnv.language.localizedString("login_logo_accessibility"))
            
            VStack(spacing: 12) {
                Text(appEnv.language.localizedString("login_title_welcome"))
                    .font(TextStyle.display)
                
                Text(appEnv.language.localizedString("login_logo_subtitle"))
                    .font(TextStyle.footnote)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
        }
    }
}

private struct QFLoginButton: View {
    var isLoading: Bool
    let action: () -> Void
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                        .tint(colors.primary)
                        .scaleEffect(1.1)
                } else {
                    Image(systemName: "q.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(colors.primary)
                }
                
                Text(isLoading ? "" : appEnv.language.localizedString("login_button_qf"))
                    .font(TextStyle.headline.bold())
            }
            .foregroundColor(colors.foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                Capsule()
                    .fill(colors.background)
                    .shadow(color: colors.foreground.opacity(0.05), radius: 10, y: 5)
            )
            .overlay(
                Capsule()
                    .stroke(colors.foreground.opacity(0.08), lineWidth: 1)
            )
        }
        .accessibilityLabel(appEnv.language.localizedString("login_accessibility_qf_button"))
        .disabled(isLoading)
    }
}


private struct LoginFooter: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: { 
            // Handle help action
        }) {
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 14))
                Text(appEnv.language.localizedString("login_button_help"))
            }
            .font(TextStyle.caption.bold())
            .foregroundColor(colors.foreground.opacity(0.35))
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Capsule().fill(colors.foreground.opacity(0.03)))
        }
        .accessibilityLabel(appEnv.language.localizedString("login_accessibility_help_button"))
    }
}


#Preview {
    LoginView()
        .environment(AppRouter())
}
