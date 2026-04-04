//
//  AboutHiraView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct AboutHiraView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    @State private var animateItems = false
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    // MARK: - Logo Section
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(LinearGradient(colors: [colors.primary, colors.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 120, height: 120)
                                .shadow(color: colors.primary.opacity(0.3), radius: 20, x: 0, y: 15)
                            
                            Image(systemName: "hand.raised.fill") // Placeholder for Hira Logo
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(animateItems ? 1 : 0.8)
                        .opacity(animateItems ? 1 : 0)
                        
                        VStack(spacing: 8) {
                            Text("Hira")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                            
                            Text(appEnv.language.localizedString("about_version"))
                                .font(.subheadline)
                                .foregroundColor(colors.foreground.opacity(0.4))
                        }
                    }
                    .padding(.top, 40)
                    
                    // MARK: - Description Section
                    VStack(alignment: .leading, spacing: 24) {
                        AboutInfoCard(
                            title: appEnv.language.localizedString("about_mission_title"),
                            content: appEnv.language.localizedString("about_mission_desc")
                        )
                        
                        AboutInfoCard(
                            title: appEnv.language.localizedString("about_crafted_title"),
                            content: appEnv.language.localizedString("about_crafted_desc")
                        )
                    }
                    .padding(.horizontal, 24)
                    .offset(y: animateItems ? 0 : 30)
                    .opacity(animateItems ? 1 : 0)
                    
                    // MARK: - Footer Links
                    VStack(spacing: 16) {
                        LinkButton(title: appEnv.language.localizedString("about_policy"), icon: "shield.lefthalf.filled")
                        LinkButton(title: appEnv.language.localizedString("about_terms"), icon: "doc.text.fill")
                        LinkButton(title: appEnv.language.localizedString("about_connect"), icon: "envelope.fill")
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 60)
                }
            }
        }
        .navigationTitle(appEnv.language.localizedString("profile_menu_about"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateItems = true
            }
        }
    }
}

private struct AboutInfoCard: View {
    let title: String
    let content: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(colors.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(colors.foreground.opacity(0.8))
                .lineSpacing(6)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(colors.foreground.opacity(0.03)))
    }
}

private struct LinkButton: View {
    let title: String
    let icon: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.body.bold())
                Text(title)
                    .font(.body.bold())
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption.bold())
                    .opacity(0.5)
            }
            .foregroundColor(colors.foreground)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).stroke(colors.foreground.opacity(0.1), lineWidth: 1))
        }
    }
}
