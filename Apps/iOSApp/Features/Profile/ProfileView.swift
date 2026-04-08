//
//  ProfileView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    // MARK: - State & Animation
    @State private var animateBackground = false
    @State private var scrollOffset: CGFloat = 0
    @Bindable var theme: ThemeManager
    
    private let headerThreshold: CGFloat = 120
    private var colors: ThemeModel { appEnv.theme.current }
    
    init(theme: ThemeManager) {
        self.theme = theme
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Immersion Background
            colors.background.ignoresSafeArea()
            BackgroundVisuals(animate: $animateBackground)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - 1. Animated Header
                    VStack(spacing: 20) {
                        profileImage
                            .scaleEffect(getHeaderScale())
                            .opacity(getHeaderOpacity())
                            .blur(radius: getHeaderBlur())
                            .accessibilityLabel(appEnv.language.localizedString("profile_accessibility_avatar"))
                        
                        VStack(spacing: 6) {
                            Text(appEnv.language.localizedString("profile_field_name"))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                            
                            Text(appEnv.language.localizedString("profile_field_email"))
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(colors.foreground.opacity(0.4))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(colors.foreground.opacity(0.04)))
                        }
                        .opacity(getHeaderOpacity())
                        .offset(y: getHeaderOffset())
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(appEnv.language.localizedString("profile_field_name")). \(appEnv.language.localizedString("profile_field_email"))")
                    }
                    .padding(.top, 100) // Increased for custom header space
                    .padding(.bottom, 40)
                    .background(
                        GeometryReader { proxy in
                            let minY = proxy.frame(in: .named("SCROLL")).minY
                            Color.clear.onAppear { scrollOffset = minY }
                                .onChange(of: minY) { _, new in scrollOffset = new }
                        }
                    )
                    
                    // MARK: - 2. Grouped Menu
                    VStack(spacing: 28) {
                        ProfileSectionView(title: appEnv.language.localizedString("profile_section_account")) {
                            ProfileMenuRow(
                                icon: "shield.fill", 
                                title: appEnv.language.localizedString("profile_menu_security"), 
                                value: appEnv.language.localizedString(appEnv.security.isPINSet ? "security_pin_active" : "security_pin_not_set")
                            ) {
                                router.navigate(to: .securitySetting)
                            }
                        }
                        
                        ProfileSectionView(title: appEnv.language.localizedString("profile_section_settings")) {
                            ProfileMenuRow(icon: "circle.grid.3x3.fill", title: appEnv.language.localizedString("profile_menu_theme"), value: appEnv.theme.variant.displayName) {
                                router.navigate(to: .themeSetting)
                            }
                            
                            ProfileMenuRow(icon: "character.bubble.fill", title: appEnv.language.localizedString("profile_menu_language"), value: appEnv.language.selectedCode == "system" ? appEnv.language.localizedString("language_system_default") : appEnv.language.selectedCode.uppercased()) {
                                router.navigate(to: .languageSetting)
                            }
                            
                            ProfileMenuRow(icon: theme.isDark ? "moon.fill" : "sun.max.fill", title: appEnv.language.localizedString("profile_menu_dark_mode")) {
                                Toggle("", isOn: $theme.isDark.animation(.spring(response: 0.4, dampingFraction: 0.7)))
                                    .labelsHidden()
                                    .tint(colors.primary)
                                    .accessibilityLabel(appEnv.language.localizedString("profile_menu_dark_mode"))
                            }
                        }
                        
                        ProfileSectionView(title: appEnv.language.localizedString("profile_section_support")) {
                            ProfileMenuRow(icon: "info.circle.fill", title: appEnv.language.localizedString("profile_menu_about")) {
                                router.navigate(to: .aboutHira)
                            }
                            ProfileMenuRow(icon: "curlybraces", title: appEnv.language.localizedString("profile_menu_version"), value: appEnv.language.localizedString("about_version"), showArrow: false) {}
                        }
                        
                        // Action: Logout
                        Button(action: { }) {
                            Text(appEnv.language.localizedString("profile_menu_logout"))
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color.red.opacity(0.1)))
                        }
                        .padding(.top, 10)
                        .accessibilityLabel(appEnv.language.localizedString("profile_menu_logout"))
                        .accessibilityHint(appEnv.language.localizedString("profile_accessibility_logout_hint"))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
            }
            .coordinateSpace(name: "SCROLL")
            
            // MARK: - Custom Navigation Bar (RELIABLE)
            VStack(spacing: 0) {
                HStack {
                    // Left spacer (equivalent to back button space)
                    Spacer().frame(width: 44)
                    
                    Spacer()
                    
                    Text(appEnv.language.localizedString("profile_field_name"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                        .opacity(getToolbarTitleOpacity())
                    
                    Spacer()
                    
                    // Edit Button (Always Visible)
                    Button(action: { router.navigate(to: .editProfile) }) {
                        Text(appEnv.language.localizedString("profile_menu_edit_profile"))
                            .font(.body.bold())
                            .foregroundColor(colors.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(colors.primary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .frame(width: 80)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .frame(height: 60)
                .background(
                    colors.background.opacity(getToolbarTitleOpacity() > 0.5 ? 0.95 : 0)
                        .blur(radius: 10)
                        .ignoresSafeArea()
                )
            }
            .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial).opacity(getToolbarTitleOpacity()).ignoresSafeArea())
        }
        .onAppear { 
            withAnimation(.easeInOut(duration: 0.8)) { animateBackground = true }
        }
    }
    
    private var profileImage: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [colors.primary, colors.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 100, height: 100)
                .shadow(color: colors.primary.opacity(0.3), radius: 15, x: 0, y: 10)
            
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Animation Helpers
    private func getHeaderOpacity() -> Double {
        let progress = -scrollOffset / 70
        return Double(1 - max(0, min(1, progress)))
    }
    
    private func getHeaderScale() -> CGFloat {
        let progress = -scrollOffset / 150
        return max(0.6, 1 - progress)
    }
    
    private func getHeaderBlur() -> CGFloat {
        let progress = -scrollOffset / 100
        return max(0, min(10, progress * 10))
    }
    
    private func getHeaderOffset() -> CGFloat {
        scrollOffset > 0 ? 0 : scrollOffset * 0.3
    }
    
    private func getToolbarTitleOpacity() -> Double {
        let progress = -scrollOffset / headerThreshold
        return Double(max(0, min(1, progress)))
    }
    
    private func getEditButtonOpacity() -> Double {
        // Keeps it visible unless extremely scrolled
        return 1.0
    }
}

// MARK: - Internal Background
private struct BackgroundVisuals: View {
    @Binding var animate: Bool
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(colors.primary.opacity(0.01))
                .frame(width: 400)
                .blur(radius: 100)
                .offset(x: animate ? -50 : 50, y: -300)
        }
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
    }
}

#Preview {
    NavigationStack {
        ProfileView(theme: ThemeManager())
            .environment(AppRouter())
    }
}
