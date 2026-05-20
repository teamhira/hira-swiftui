//
//  KhatamProgressCard.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct KhatamProgressCard: View {
    let goal: KhatamGoal
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(goal.title)
                        .font(TextStyle.headline)
                        .foregroundColor(colors.foreground)
                    
                    Text(appEnv.language.localizedString("khatam_progress_desc"))
                        .font(TextStyle.caption)
                        .foregroundColor(colors.foreground.opacity(0.6))
                }
                Spacer()
                
                CircularProgressView(progress: goal.progress, colors: colors)
                    .frame(width: 50, height: 50)
            }
            
            ProgressView(value: goal.progress)
                .tint(colors.primary)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .clipShape(Capsule())
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(appEnv.language.localizedString("khatam_status_surah", arguments: [goal.lastSurah]))
                        .font(TextStyle.caption)
                        .fontWeight(.bold)
                    
                    Text(appEnv.language.localizedString("khatam_status_ayah", arguments: [goal.currentAyahCount, goal.totalAyahs]))
                        .font(.system(size: 10))
                        .foregroundColor(colors.foreground.opacity(0.6))
                }
                
                Spacer()
                
                Text(appEnv.language.localizedString("khatam_percentage_format", arguments: [goal.progressPercentage]))
                    .font(TextStyle.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(colors.foreground)

        }
        .padding(AppSpacing.lg)
        .background(colors.card)
        .cornerRadius(20)
        .shadow(
            color: AppShadow.card.color,
            radius: AppShadow.card.radius,
            x: AppShadow.card.x,
            y: AppShadow.card.y
        )
    }

}

struct CircularProgressView: View {
    let progress: Double
    let colors: ThemeModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(colors.primary.opacity(0.1), lineWidth: 5)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(colors.primary, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
