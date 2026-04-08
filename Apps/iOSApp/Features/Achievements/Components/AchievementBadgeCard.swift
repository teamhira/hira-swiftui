//
//  AchievementBadgeCard.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct AchievementBadgeCard: View {
    let achievement: Achievement
    let colors: ThemeModel
    let appEnv: AppEnvironment
    let history: AchievementHistory?
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isLocked ? Color.secondary.opacity(0.1) : colors.primary.opacity(0.1))
                    .frame(width: 64, height: 64)
                
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isLocked ? .secondary.opacity(0.4) : colors.primary)
                    .grayscale(achievement.isLocked ? 1.0 : 0.0)
                
                if achievement.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.secondary.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 20, y: 20)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(achievement.isLocked ? colors.foreground.opacity(0.4) : colors.foreground)
                
                if let history = history {
                    Text(appEnv.language.localizedString("achievement_earned_on", arguments: [formatDate(history.date)]))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                } else {
                    Text(achievement.description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if !achievement.isLocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(colors.primary)
                    .font(.title3)
            } else {
                Text("\(achievement.xp) XP")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.6))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(colors.background)
        )
        .hiraCleanCard(colors: colors, radius: 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("achievement_accessibility_badge_item", arguments: [achievement.title, achievement.isLocked ? "0" : "100"]))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
