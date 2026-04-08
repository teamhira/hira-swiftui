//
//  AchievementStatsHeader.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct AchievementStatsHeader: View {
    @Environment(\.appEnvironment) private var appEnv
    let colors: ThemeModel
    let level: Int
    let levelName: String
    let currentXP: Int
    let maxXP: Int
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            // Level Circle
            ZStack {
                Circle()
                    .stroke(colors.primary.opacity(0.1), lineWidth: 10)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        LinearGradient(
                            colors: [colors.primary, colors.primary.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 4) {
                    Text("\(level)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                        .contentTransition(.numericText())
                    
                    Text(levelName.uppercased())
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                }
            }
            .padding(.top, 10)
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("achievement_xp", arguments: [currentXP, maxXP]))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("achievement_xp_to_next_level", arguments: [maxXP - currentXP, level + 1]))
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(colors.background)
        )
        .hiraCleanCard(colors: colors, radius: 32)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("achievement_accessibility_level_card", arguments: [level, "\(currentXP) / \(maxXP)"]))
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8)) {
                animatedProgress = Double(currentXP) / Double(maxXP)
            }
        }
        .onChange(of: currentXP) {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8)) {
                animatedProgress = Double(currentXP) / Double(maxXP)
            }
        }
    }
}
