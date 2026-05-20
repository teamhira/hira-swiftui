//
//  TrackerItemRow.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct TrackerItemRow: View {
    let entry: TrackerEntry
    let colors: ThemeModel
    let onToggle: () -> Void
    
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: AppSpacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(entry.isCompleted ? colors.primary.opacity(0.1) : colors.foreground.opacity(0.05))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: entry.type.icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(entry.isCompleted ? colors.primary : colors.foreground.opacity(0.4))
                }
                
                // Title
                Text(appEnv.language.localizedString(entry.type.titleKey))
                    .font(TextStyle.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(colors.foreground)
                
                Spacer()
                
                // Checkmark
                ZStack {
                    Circle()
                        .stroke(entry.isCompleted ? colors.primary : colors.foreground.opacity(0.1), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if entry.isCompleted {
                        Circle()
                            .fill(colors.primary)
                            .frame(width: 20, height: 20)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(colors.card)
            .cornerRadius(20)
            .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
        }
        .buttonStyle(.plain)
    }
}
