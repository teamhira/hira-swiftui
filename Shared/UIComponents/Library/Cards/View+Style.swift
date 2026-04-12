//
//  View+Style.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

public extension View {
    
    /// Standard clean card modifier for the Hira app.
    /// Replaces the old style that used borders and heavy shadows.
    func hiraCardStyle(cornerRadius: CGFloat = 24, padding: CGFloat = 0) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(UIColor.systemBackground)) // We'll map this to theme colors in use cases
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
    
    /// Applies the specific clean card style requested by the user, incorporating theme awareness.
    func hiraCleanCard(colors: ThemeModel, radius: CGFloat = 24) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(colors.background)
            )
            .shadow(color: colors.foreground.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    /// Primary button style for Hira app.
    func hiraPrimaryButton(colors: ThemeModel) -> some View {
        self
            .font(.headline.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(colors.primary)
            .clipShape(Capsule())
            .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

