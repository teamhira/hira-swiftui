//
//  TypingIndicator.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct TypingIndicator: View {
    let colors: ThemeModel
    @State private var dotScale: CGFloat = 0.5
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(colors.primary.opacity(0.5))
                        .frame(width: 6, height: 6)
                        .scaleEffect(dotScale)
                        .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2), value: dotScale)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(colors.card)
            .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
            .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
            
            Text(appEnv.language.localizedString("chatbot_typing"))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.3))
        }
        .onAppear { dotScale = 1.0 }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
