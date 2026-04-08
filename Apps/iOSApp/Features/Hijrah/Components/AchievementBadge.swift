//
//  AchievementBadge.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct AchievementBadge: View {
    let icon: String
    let label: String
    let colors: ThemeModel
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.06))
                    .frame(width: 64, height: 64)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(colors.primary)
            }
            .overlay(
                Circle()
                    .stroke(colors.primary.opacity(0.1), lineWidth: 1)
            )
            
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.8))
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}
