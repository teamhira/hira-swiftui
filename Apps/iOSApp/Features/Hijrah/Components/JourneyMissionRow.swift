//
//  JourneyMissionRow.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct JourneyMissionRow: View {
    let title: String
    let colors: ThemeModel
    @State private var isCompleted = false
    
    var body: some View {
        Button(action: { withAnimation { isCompleted.toggle() } }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? colors.primary : Color.clear)
                        .frame(width: 28, height: 28)
                        .overlay(Circle().stroke(isCompleted ? colors.primary : colors.foreground.opacity(0.1), lineWidth: 2))
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                    }
                }
                .accessibilityLabel(isCompleted ? "Completed" : "Incomplete")
                
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundColor(isCompleted ? .secondary : colors.foreground)
                    .strikethrough(isCompleted)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(colors.foreground.opacity(0.2))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(colors.background)
                    .hiraCleanCard(colors: colors, radius: 20)
            )
            .opacity(isCompleted ? 0.7 : 1)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityHint("Double tap to toggle completion status")
    }
}
