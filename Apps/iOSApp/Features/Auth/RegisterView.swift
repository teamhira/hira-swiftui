//
//  RegisterView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct RegisterView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmVisible = false
    @State private var animateItems = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // MARK: - Immersive Background
            BackgroundVisuals(animate: $animateItems)
            
            VStack(spacing: 0) {
                // MARK: - 1. Compact Header
                RegisterHeader()
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // MARK: - 2. Registration Form
                        RegisterForm(
                            fullName: $fullName,
                            email: $email,
                            password: $password,
                            confirmPassword: $confirmPassword,
                            isPasswordVisible: $isPasswordVisible,
                            isConfirmVisible: $isConfirmVisible
                        )
                        
                        // MARK: - 3. Social Sign Up
                        SocialRegisterSection()
                        
                        // MARK: - 4. Footer Navigation
                        RegisterFooter()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, 30)
                }
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
                .fill(colors.secondary.opacity(0.08))
                .frame(width: 300)
                .blur(radius: 80)
                .offset(x: animate ? 60 : -60, y: -220)
        }
        .accessibilityHidden(true)
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
    }
}

private struct RegisterHeader: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .shadow(color: colors.primary.opacity(0.1), radius: 8, y: 4)
                .accessibilityLabel(appEnv.language.localizedString("login_accessibility_logo"))
            
            VStack(spacing: 6) {
                Text(appEnv.language.localizedString("register_title"))
                    .font(TextStyle.display)
                
                Text(appEnv.language.localizedString("register_subtitle"))
                    .font(TextStyle.footnote)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
            }
        }
    }
}

private struct RegisterForm: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var isPasswordVisible: Bool
    @Binding var isConfirmVisible: Bool
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 12) {
            // Full Name
            inputContainer {
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundColor(colors.primary.opacity(0.7))
                        .frame(width: 20)
                        .accessibilityHidden(true)
                    TextField(appEnv.language.localizedString("register_field_name"), text: $fullName)
                        .font(TextStyle.body)
                        .accessibilityLabel(appEnv.language.localizedString("register_accessibility_name_input"))
                }
            }
            
            // Email
            inputContainer {
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(colors.primary.opacity(0.7))
                        .frame(width: 20)
                        .accessibilityHidden(true)
                    TextField(appEnv.language.localizedString("register_field_email"), text: $email)
                        .font(TextStyle.body)
                        .accessibilityLabel(appEnv.language.localizedString("register_accessibility_email_input"))
                }
            }
            
            // Password
            inputContainer {
                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(colors.primary.opacity(0.7))
                        .frame(width: 20)
                        .accessibilityHidden(true)
                    
                    if isPasswordVisible {
                        TextField(appEnv.language.localizedString("register_field_password"), text: $password)
                            .accessibilityLabel(appEnv.language.localizedString("register_accessibility_password_input"))
                    } else {
                        SecureField(appEnv.language.localizedString("register_field_password"), text: $password)
                            .accessibilityLabel(appEnv.language.localizedString("register_accessibility_password_input"))
                    }
                    
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(colors.foreground.opacity(0.25))
                    }
                    .accessibilityLabel(appEnv.language.localizedString(isPasswordVisible ? "accessibility_password_hide" : "accessibility_password_show"))
                }
            }
            
            // Confirm Password
            inputContainer {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(colors.primary.opacity(0.7))
                        .frame(width: 20)
                        .accessibilityHidden(true)
                    
                    if isConfirmVisible {
                        TextField(appEnv.language.localizedString("register_field_confirm_password"), text: $confirmPassword)
                            .accessibilityLabel(appEnv.language.localizedString("register_accessibility_confirm_password_input"))
                    } else {
                        SecureField(appEnv.language.localizedString("register_field_confirm_password"), text: $confirmPassword)
                            .accessibilityLabel(appEnv.language.localizedString("register_accessibility_confirm_password_input"))
                    }
                    
                    Button(action: { isConfirmVisible.toggle() }) {
                        Image(systemName: isConfirmVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(colors.foreground.opacity(0.25))
                    }
                    .accessibilityLabel(appEnv.language.localizedString(isConfirmVisible ? "accessibility_password_hide" : "accessibility_password_show"))
                }
            }
            
            // Sign Up Button
            Button(action: { }) {
                Text(appEnv.language.localizedString("register_button_signup"))
                    .font(TextStyle.headline.bold())
                    .foregroundColor(colors.primaryForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Capsule().fill(colors.primary))
                    .shadow(color: colors.primary.opacity(0.25), radius: 15, y: 10)
            }
            .accessibilityLabel(appEnv.language.localizedString("register_accessibility_signup_button"))
            .padding(.top, 4)
        }
    }
    
    @ViewBuilder
    private func inputContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(.horizontal, AppSpacing.lg)
            .frame(height: 56)
            .background(Capsule().fill(colors.background))
            .shadow(color: colors.foreground.opacity(0.02), radius: 10, y: 5)
    }
}

private struct SocialRegisterSection: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Rectangle().fill(colors.foreground.opacity(0.08)).frame(height: 1)
                Text(appEnv.language.localizedString("register_divider_social"))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.35))
                Rectangle().fill(colors.foreground.opacity(0.08)).frame(height: 1)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .combine)
            
            VStack(spacing: 12) {
                socialButton(
                    icon: AnyView(Image(systemName: "apple.logo")),
                    title: appEnv.language.localizedString("register_button_apple"),
                    accessibility: appEnv.language.localizedString("register_accessibility_apple_button"),
                    color: colors.foreground
                )
                
                socialButton(
                    icon: AnyView(GoogleLogoView()),
                    title: appEnv.language.localizedString("register_button_google"),
                    accessibility: appEnv.language.localizedString("register_accessibility_google_button"),
                    color: .clear
                )
            }
        }
    }
    
    private func socialButton(icon: AnyView, title: String, accessibility: String, color: Color) -> some View {
        Button(action: { }) {
            HStack(spacing: 12) {
                icon.font(.system(size: 20, weight: .medium))
                    .foregroundColor(color == .clear ? .primary : color)
                Text(title)
                    .font(TextStyle.footnote.bold())
            }
            .foregroundColor(colors.foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Capsule().stroke(colors.foreground.opacity(0.1), lineWidth: 1))
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

private struct RegisterFooter: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                Text(appEnv.language.localizedString("register_footer_login_prompt"))
                    .font(TextStyle.footnote)
                    .foregroundColor(colors.foreground.opacity(0.4))
                
                Button(action: { router.pop() }) {
                    Text(appEnv.language.localizedString("register_footer_login_button"))
                        .font(TextStyle.footnote.bold())
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel(appEnv.language.localizedString("register_accessibility_login_button"))
            }
            
            Button(action: { }) {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle")
                        .accessibilityHidden(true)
                    Text(appEnv.language.localizedString("register_button_help"))
                }
                .font(TextStyle.caption.bold())
                .foregroundColor(colors.foreground.opacity(0.3))
            }
            .accessibilityLabel(appEnv.language.localizedString("login_accessibility_help_button"))
        }
    }
}

#Preview {
    RegisterView()
        .environment(AppRouter())
}
