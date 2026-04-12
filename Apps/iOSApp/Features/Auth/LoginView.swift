//
//  LoginView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct LoginView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var animateItems = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            BackgroundVisuals(animate: $animateItems)
            
            VStack(spacing: 0) {
                // MARK: - 1. Compact Header
                LoginHeader()
                    .padding(.top, 40)
                    .padding(.bottom, AppSpacing.xl)
                
                VStack(spacing: AppSpacing.xl) {
                    // MARK: - 2. Form Area
                    LoginForm(
                        email: $email,
                        password: $password,
                        isPasswordVisible: $isPasswordVisible
                    )
                    
                    VStack(spacing: AppSpacing.lg) {
                        // MARK: - 3. Guest Action
                        Button(action: { router.popToRoot() }) {
                            Text(appEnv.language.localizedString("login_button_guest"))
                                .font(TextStyle.subheadline.bold())
                                .foregroundColor(colors.primary)
                        }
                        .accessibilityLabel(appEnv.language.localizedString("login_accessibility_guest_button"))
                        
                        // MARK: - 4. Social Login Section
                        SocialLoginSection()
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer(minLength: 40)
                
                // MARK: - 5. Refined Footer
                LoginFooter()
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
                .offset(x: animate ? -60 : 60, y: -220)
        }
        .accessibilityHidden(true)
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
    }
}

private struct LoginHeader: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 24) {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .shadow(color: colors.primary.opacity(0.1), radius: 10, y: 5)
                .accessibilityLabel(appEnv.language.localizedString("login_logo_accessibility"))
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("login_title_welcome"))
                    .font(TextStyle.display)
                
                Text(appEnv.language.localizedString("login_logo_subtitle"))
                    .font(TextStyle.footnote)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(2)
            }
        }
    }
}

private struct LoginForm: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 14) {
            inputContainer {
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(colors.primary.opacity(0.7))
                        .frame(width: 20)
                        .accessibilityHidden(true)
                    TextField(appEnv.language.localizedString("login_email_placeholder"), text: $email)
                        .font(TextStyle.body)
                        .accessibilityLabel(appEnv.language.localizedString("login_accessibility_email_input"))
                }
            }
            
            VStack(alignment: .trailing, spacing: 10) {
                inputContainer {
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(colors.primary.opacity(0.7))
                            .frame(width: 20)
                            .accessibilityHidden(true)
                        
                        if isPasswordVisible {
                            TextField(appEnv.language.localizedString("login_password_placeholder"), text: $password)
                                .accessibilityLabel(appEnv.language.localizedString("login_accessibility_password_input"))
                        } else {
                            SecureField(appEnv.language.localizedString("login_password_placeholder"), text: $password)
                                .accessibilityLabel(appEnv.language.localizedString("login_accessibility_password_input"))
                        }
                        
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(colors.foreground.opacity(0.25))
                        }
                        .accessibilityLabel(appEnv.language.localizedString(isPasswordVisible ? "accessibility_password_hide" : "accessibility_password_show"))
                    }
                }
                
                Button(action: { }) {
                    Text(appEnv.language.localizedString("login_button_forgot_password"))
                        .font(TextStyle.caption.bold())
                        .foregroundColor(colors.primary)
                        .padding(.trailing, 8)
                }
                .accessibilityLabel(appEnv.language.localizedString("login_accessibility_forgot_password"))
            }
            .padding(.bottom, 6)
            
            Button(action: { }) {
                Text(appEnv.language.localizedString("login_button_signin"))
                    .font(TextStyle.headline.bold())
                    .foregroundColor(colors.primaryForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Capsule().fill(colors.primary))
                    .shadow(color: colors.primary.opacity(0.25), radius: 15, y: 10)
            }
            .accessibilityLabel(appEnv.language.localizedString("login_accessibility_signin_button"))
        }
    }
    
    @ViewBuilder
    private func inputContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(.horizontal, AppSpacing.lg)
            .frame(height: 60)
            .background(Capsule().fill(colors.background))
            .shadow(color: colors.foreground.opacity(0.02), radius: 10, y: 5) // Subtle shadow for input
    }
}

private struct SocialLoginSection: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                Rectangle().fill(colors.foreground.opacity(0.08)).frame(height: 1)
                Text(appEnv.language.localizedString("login_divider_social"))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.35))
                Rectangle().fill(colors.foreground.opacity(0.08)).frame(height: 1)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .combine)
            
            VStack(spacing: 12) {
                socialButton(
                    icon: AnyView(Image(systemName: "apple.logo")),
                    title: appEnv.language.localizedString("login_button_apple"),
                    accessibility: appEnv.language.localizedString("login_accessibility_apple_button"),
                    color: colors.foreground
                )
                
                socialButton(
                    icon: AnyView(GoogleLogoView()),
                    title: appEnv.language.localizedString("login_button_google"),
                    accessibility: appEnv.language.localizedString("login_accessibility_google_button"),
                    color: .clear
                )
            }
        }
        .padding(.top, 10)
    }
    
    private func socialButton(icon: AnyView, title: String, accessibility: String, color: Color) -> some View {
        Button(action: { }) {
            HStack(spacing: 14) {
                icon.font(.system(size: 20, weight: .medium))
                    .foregroundColor(color == .clear ? .primary : color)
                Text(title)
                    .font(TextStyle.footnote.bold())
            }
            .foregroundColor(colors.foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Capsule().fill(colors.background))
            .overlay(Capsule().stroke(colors.foreground.opacity(0.1), lineWidth: 1))
        }
        .accessibilityLabel(accessibility)
    }
}

private struct GoogleLogoView: View {
    var body: some View {
        Image("GoogleLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .accessibilityHidden(true)
    }
}

private struct LoginFooter: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 4) {
                Text(appEnv.language.localizedString("login_footer_signup_prompt"))
                    .font(TextStyle.footnote)
                    .foregroundColor(colors.foreground.opacity(0.4))
                
                Button(action: { router.navigate(to: .register) }) {
                    Text(appEnv.language.localizedString("login_footer_signup_button"))
                        .font(TextStyle.footnote.bold())
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel(appEnv.language.localizedString("login_accessibility_signup_button"))
            }
            
            Button(action: { }) {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle")
                        .accessibilityHidden(true)
                    Text(appEnv.language.localizedString("login_button_help"))
                }
                .font(TextStyle.caption.bold())
                .foregroundColor(colors.foreground.opacity(0.3))
            }
            .accessibilityLabel(appEnv.language.localizedString("login_accessibility_help_button"))
        }
    }
}

#Preview {
    LoginView()
        .environment(AppRouter())
}
