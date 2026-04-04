//
//  CharityCategoryIcon.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct CharityCategoryIcon: View {
    let title: String
    let icon: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colors.foreground.opacity(0.04))
                    .frame(width: 64, height: 64)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(colors.primary)
            }
            
            Text(title)
                .font(.caption.bold())
                .foregroundColor(colors.foreground)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .hiraCleanCard(colors: colors)
    }
}
