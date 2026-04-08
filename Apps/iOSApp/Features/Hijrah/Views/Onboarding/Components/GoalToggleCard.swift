//
//  GoalToggleCard.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct GoalToggleCard: View {
    let title: String
    let isSelected: Bool
    let colors: ThemeModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? colors.primary.opacity(0.15) : colors.foreground.opacity(0.05))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: isSelected ? "checkmark" : "circle")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isSelected ? colors.primary : colors.foreground.opacity(0.2))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium, design: .rounded))
                    .foregroundColor(isSelected ? colors.primary : colors.foreground)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? colors.primary.opacity(0.05) : colors.background)
                    .hiraCleanCard(colors: colors, radius: 18)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? colors.primary.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
            .scaleEffect(isSelected ? 1.01 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
