//
//  CharityQuickSearchChip.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct CharityQuickSearchChip: View {
    let title: String
    let icon: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.primary)
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.foreground)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    Capsule()
                        .fill(colors.primary.opacity(0.08))
                    Capsule()
                        .fill(LinearGradient(colors: [Color.white.opacity(0.1), Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            )
            .overlay(
                Capsule()
                    .stroke(colors.primary.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

