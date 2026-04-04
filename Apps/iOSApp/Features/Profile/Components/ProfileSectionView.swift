//
//  ProfileSectionView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct ProfileSectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Section Title
            Text(title.uppercased())
                .font(TextStyle.caption.bold())
                .foregroundColor(colors.foreground.opacity(0.4))
                .kerning(1.2)
                .padding(.horizontal, 20)
            
            // MARK: - Section Content
            VStack(spacing: 12) {
                content()
            }
        }
        .padding(.vertical, 10)
    }
}
