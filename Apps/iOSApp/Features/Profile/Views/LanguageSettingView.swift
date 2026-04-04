//
//  LanguageSettingView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct LanguageSettingView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    private var colors: ThemeModel { appEnv.theme.current }
    
    // Temporary state to hold selection until saved
    @State private var selectedLangCode: String = ""
    @State private var animateItems = false
    
    // Languages list with keys for the system default
    private var languages: [(name: String, flag: String, code: String)] {
        [
            (name: appEnv.language.localizedString("language_system_default"), flag: "⚙️", code: "system"),
            (name: "Bahasa Indonesia", flag: "🇮🇩", code: "id"),
            (name: "English", flag: "🇺🇸", code: "en"),
            (name: "Bahasa Melayu", flag: "🇲🇾", code: "ms"),
            (name: "العربية", flag: "🇸🇦", code: "ar")
        ]
    }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            // Re-use background visuals
            BackgroundVisuals(animate: $animateItems)
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(appEnv.language.localizedString("language_title_choose"))
                                .font(.headline)
                                .foregroundColor(colors.foreground)
                            
                            Text(appEnv.language.localizedString("language_desc_choose"))
                                .font(.subheadline)
                                .foregroundColor(colors.foreground.opacity(0.4))
                        }
                        .padding(.top, 24)
                        
                        VStack(spacing: 16) {
                            ForEach(languages, id: \.code) { lang in
                                LanguageRow(
                                    flag: lang.flag,
                                    name: lang.name,
                                    isSelected: selectedLangCode == lang.code
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedLangCode = lang.code
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .offset(y: animateItems ? 0 : 20)
                    .opacity(animateItems ? 1 : 0)
                }
                
                // Bottom Fixed Action
                VStack(spacing: 0) {
                    Divider().opacity(0.1)
                    Button(action: {
                        appEnv.language.setLanguage(selectedLangCode)
                        dismiss()
                    }) {
                        Text(appEnv.language.localizedString("language_button_apply"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Capsule().fill(colors.primary))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                    }
                }
                .background(colors.background.ignoresSafeArea())
            }
        }
        .navigationTitle(appEnv.language.localizedString("profile_menu_language"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedLangCode = appEnv.language.selectedCode
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateItems = true
            }
        }
        // Ensure RTL/LTR support for this view via environment
        .environment(\.layoutDirection, appEnv.language.layoutDirection)
    }
}

private struct LanguageRow: View {
    let flag: String
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(isSelected ? colors.primary.opacity(0.12) : colors.foreground.opacity(0.04))
                        .frame(width: 52, height: 52)
                    
                    Text(flag)
                        .font(.title3)
                }
                
                Text(name)
                    .font(.body.weight(.semibold))
                    .foregroundColor(colors.foreground)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(colors.primary)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isSelected ? colors.primary.opacity(0.04) : colors.foreground.opacity(0.02))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isSelected ? colors.primary.opacity(0.2) : Color.clear, lineWidth: 1.5)
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
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
        LanguageSettingView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
