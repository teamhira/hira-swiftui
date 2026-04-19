//
//  MiscComponents.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct SectionHeaderView: View {
    let title: String
    let icon: String
    var onViewAll: (() -> Void)?
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(.secondary)
                Text(title).font(.system(size: 20, weight: .bold))
            }
            Spacer()
            Button(action: { onViewAll?() }) {
                HStack(spacing: 4) {
                    Text(appEnv.language.localizedString("home_articles_all")).font(.system(size: 14, weight: .medium))
                    Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 24)
    }
}

public struct HiraToast: View {
    let message: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill").foregroundColor(colors.primary)
            Text(message).font(.system(size: 14, weight: .bold))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Capsule().fill(colors.background).shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5))
        .overlay(Capsule().stroke(colors.primary.opacity(0.2), lineWidth: 1))
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
