//
//  ProfileHeaderView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Avatar with Ring
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Circle()
                    .stroke(colors.primary.opacity(0.2), lineWidth: 2)
                    .frame(width: 112, height: 112)
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundColor(colors.primary)
            }
            .accessibilityLabel(appEnv.language.localizedString("profile_accessibility_avatar"))
            
            // MARK: - User Info
            VStack(spacing: 4) {
                Text(appEnv.language.localizedString("profile_name_placeholder", defaultValue: "Kira"))
                    .font(TextStyle.title2.bold())
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("profile_email_placeholder", defaultValue: "kira@hira.app"))
                    .font(TextStyle.footnote)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
            
            // MARK: - Edit Action
            Button(action: { }) {
                Text(appEnv.language.localizedString("profile_menu_edit_profile"))
                    .font(TextStyle.caption.bold())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(colors.primary.opacity(0.1)))
                    .foregroundColor(colors.primary)
            }
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                colors.primary.opacity(0.03)
                colors.background.opacity(0.5)
            }
            .blur(radius: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }
}
