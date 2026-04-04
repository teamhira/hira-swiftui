//
//  ForgotPasswordView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

public struct ForgotPasswordView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var email = ""
    @State private var animateItems = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // MARK: - Animated Background
            BackgroundVisuals(animate: $animateItems)
            
            VStack(spacing: 0) {
                // MARK: - 1. Header
                ForgotPasswordHeader()
                    .padding(.top, 40)
                    .padding(.bottom, 32)
                
                VStack(spacing: 32) {
                    // MARK: - 2. Recovery Form
                    ForgotPasswordForm(email: $email)
                    
                    // MARK: - 3. Simple Back Action
                    Button(action: { router.pop() }) {
                        Text(appEnv.language.localizedString("forgot_password_footer_back"))
                            .font(TextStyle.subheadline.bold())
                            .foregroundColor(colors.primary)
                    }
                    .accessibilityLabel(appEnv.language.localizedString("forgot_password_accessibility_back_button"))
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer()
                
                // MARK: - 4. Isolated Help Button (At the very bottom)
                Button(action: { }) {
                    HStack(spacing: 6) {
                        Image(systemName: "questionmark.circle")
                            .accessibilityHidden(true)
                        Text(appEnv.language.localizedString("forgot_password_button_help"))
                    }
                    .font(TextStyle.caption.bold())
                    .foregroundColor(colors.foreground.opacity(0.3))
                }
                .accessibilityLabel(appEnv.language.localizedString("forgot_password_accessibility_help_button"))
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.pop() }) {
                    Image(systemName: "arrow.left")
                        .font(.headline)
                        .foregroundColor(colors.foreground)
                }
                .accessibilityLabel(appEnv.language.localizedString("accessibility_button_back"))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) { animateItems = true }
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
                .fill(colors.primary.opacity(0.08))
                .frame(width: 300)
                .blur(radius: 80)
                .offset(x: animate ? -30 : 30, y: -250)
        }
        .accessibilityHidden(true)
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
    }
}

private struct ForgotPasswordHeader: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundColor(colors.primary)
                    .shadow(color: colors.primary.opacity(0.2), radius: 10, y: 5)
                    .accessibilityLabel(appEnv.language.localizedString("login_accessibility_logo"))
            }
            .padding(.bottom, 4)
            
            Text(appEnv.language.localizedString("forgot_password_title"))
                .font(TextStyle.display)
            
            Text(appEnv.language.localizedString("forgot_password_subtitle"))
                .font(TextStyle.footnote)
                .foregroundColor(colors.foreground.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
                .lineSpacing(3)
        }
    }
}

private struct ForgotPasswordForm: View {
    @Binding var email: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 20) {
            // Email Input
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(colors.primary.opacity(0.7))
                    .frame(width: 20)
                    .accessibilityHidden(true)
                TextField(appEnv.language.localizedString("forgot_password_field_email"), text: $email)
                    .font(TextStyle.body)
                    .accessibilityLabel(appEnv.language.localizedString("forgot_password_accessibility_email_input"))
            }
            .padding(.horizontal, AppSpacing.lg)
            .frame(height: 60)
            .background(Capsule().fill(colors.background))
            .shadow(color: colors.foreground.opacity(0.02), radius: 10, y: 5)
            
            // Send Reset Link Button
            Button(action: { }) {
                Text(appEnv.language.localizedString("forgot_password_button_send"))
                    .font(TextStyle.headline.bold())
                    .foregroundColor(colors.primaryForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Capsule().fill(colors.primary))
                    .shadow(color: colors.primary.opacity(0.25), radius: 15, y: 10)
            }
            .accessibilityLabel(appEnv.language.localizedString("forgot_password_accessibility_send_button"))
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environment(AppRouter())
}
