//
//  EditProfileView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.appEnvironment) private var appEnv
    
    // MARK: - State
    @State private var name = "Kira"
    @State private var username = "kira_hira"
    @State private var email = "kira@hira.app"
    @State private var phone = "+62 812 3456 789"
    @State private var bio = "Mencari ridho Allah melalui teknologi dan Al-Quran."
    @State private var animateItems = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            // Re-using background visuals for design consistency
            BackgroundVisuals(animate: .constant(true))
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - 1. Profile Photo Header
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(LinearGradient(colors: [colors.primary, colors.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 110, height: 110)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: colors.primary.opacity(0.3), radius: 15, x: 0, y: 10)
                            
                            Button(action: {}) {
                                Circle()
                                    .fill(colors.background)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.caption2.bold())
                                            .foregroundColor(colors.primary)
                                    )
                                    .shadow(radius: 4)
                            }
                        }
                    }
                    .padding(.top, 24)
                    .scaleEffect(animateItems ? 1 : 0.8)
                    .opacity(animateItems ? 1 : 0)
                    
                    // MARK: - 2. Form Sections
                    VStack(spacing: 28) {
                        // Section 1: Identity
                        ProfileSectionView(title: appEnv.language.localizedString("profile_section_account")) {
                            VStack(spacing: 0) {
                                EditField(label: appEnv.language.localizedString("profile_field_name"), icon: "person.text.rectangle", text: $name)
                                Divider().padding(.leading, 48).opacity(0.1)
                                EditField(label: appEnv.language.localizedString("profile_field_username"), icon: "at", text: $username, prefix: "@")
                            }
                        }
                        
                        // Section 2: Bio
                        ProfileSectionView(title: appEnv.language.localizedString("profile_field_bio")) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top, spacing: 16) {
                                    Image(systemName: "quote.opening")
                                        .foregroundColor(colors.primary.opacity(0.5))
                                    TextEditor(text: $bio)
                                        .frame(height: 80)
                                        .font(.body)
                                        .scrollContentBackground(.hidden)
                                }
                                
                                Text(appEnv.language.localizedString("profile_bio_hint"))
                                    .font(.caption2)
                                    .foregroundColor(colors.foreground.opacity(0.4))
                                    .padding(.leading, 32)
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // Section 3: Contact Info
                        ProfileSectionView(title: appEnv.language.localizedString("profile_section_info")) {
                            VStack(spacing: 0) {
                                EditField(label: appEnv.language.localizedString("profile_field_email"), icon: "envelope.badge", text: .constant(email), isEditable: false)
                                Divider().padding(.leading, 48).opacity(0.1)
                                EditField(label: appEnv.language.localizedString("profile_field_phone"), icon: "phone.and.waveform", text: $phone)
                            }
                        }
                    }
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .navigationTitle(appEnv.language.localizedString("profile_menu_edit_profile"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(appEnv.language.localizedString("profile_button_cancel")) { dismiss() }
                    .foregroundColor(colors.foreground)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(appEnv.language.localizedString("profile_button_done")) { dismiss() }
                    .font(.body.bold())
                    .foregroundColor(colors.primary)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateItems = true
            }
        }
    }
}

private struct EditField: View {
    let label: String
    let icon: String
    @Binding var text: String
    var prefix: String? = nil
    var isEditable: Bool = true
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(colors.primary.opacity(0.6))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption2.bold())
                    .foregroundColor(colors.foreground.opacity(0.4))
                
                HStack(spacing: 0) {
                    if let prefix = prefix {
                        Text(prefix)
                            .foregroundColor(colors.foreground.opacity(0.3))
                            .font(.body.bold())
                    }
                    TextField("", text: $text)
                        .font(.body.weight(.medium))
                        .foregroundColor(isEditable ? colors.foreground : colors.foreground.opacity(0.6))
                        .disabled(!isEditable)
                }
            }
        }
        .padding(.vertical, 12)
    }
}

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
        EditProfileView()
    }
}
