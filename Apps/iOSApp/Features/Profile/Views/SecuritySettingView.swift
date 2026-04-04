//
//  SecuritySettingView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

public struct SecuritySettingView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        @Bindable var security = appEnv.security
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    VStack(spacing: 28) {
                        // Section 1: Traditional Security
                        ProfileSectionView(title: appEnv.language.localizedString("security_section_methods")) {
                            ProfileMenuRow(
                                icon: "key.viewfinder",
                                title: appEnv.language.localizedString(security.isPINSet ? "security_method_pin_change" : "security_method_pin_setup"),
                                value: appEnv.language.localizedString(security.isPINSet ? "security_pin_active" : "security_pin_not_set")
                            ) {
                                if security.isPINSet {
                                    router.navigate(to: .pin(.change))
                                } else {
                                    router.navigate(to: .pin(.create))
                                }
                            }
                            
                            ProfileMenuRow(icon: "faceid", title: appEnv.language.localizedString("security_method_biometric")) {
                                Toggle("", isOn: $security.isBiometricEnabled)
                                    .tint(colors.primary)
                                    .disabled(!security.isPINSet)
                                    .labelsHidden()
                            }
                            .accessibilityHint(appEnv.language.localizedString("security_accessibility_biometric_toggle_hint"))
                        }
                        
                        // Section 2: Account Integrity
                        ProfileSectionView(title: appEnv.language.localizedString("security_section_integrity")) {
                            ProfileMenuRow(icon: "lock.shield.fill", title: appEnv.language.localizedString("security_integrity_autolock"), value: appEnv.language.localizedString("security_status_off")) {
                                // Logic placeholder
                            }
                            ProfileMenuRow(icon: "clock.badge.checkmark.fill", title: appEnv.language.localizedString("security_integrity_history")) {
                                // Logic placeholder
                            }
                        }
                        
                        // Section 3: Danger Zone
                        if security.isPINSet {
                            ProfileSectionView(title: appEnv.language.localizedString("security_section_danger")) {
                                Button(action: { security.resetSecurity() }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                        Text(appEnv.language.localizedString("security_button_remove_pin"))
                                            .font(.body.weight(.medium))
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                }
                                .accessibilityHint(appEnv.language.localizedString("security_accessibility_danger_hint"))
                            }
                        }
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .navigationTitle(appEnv.language.localizedString("security_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
