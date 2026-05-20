//
//  KhatamTimelineView.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI
import Combine

struct KhatamTimelineView: View {
    let goal: KhatamGoal
    let viewModel: KhatamViewModel
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var expandedRow: String? = nil
    
    var body: some View {
// ... (rest of the body is fine)
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(appEnv.language.localizedString("khatam_recommendation_title"))
                .font(TextStyle.headline)
                .foregroundColor(colors.foreground)
            
            VStack(spacing: AppSpacing.sm) {
                recommendationRow(
                    id: "daily",
                    title: appEnv.language.localizedString("khatam_daily_target"),
                    value: appEnv.language.localizedString("khatam_target_ayahs", arguments: [goal.dailyTarget]),
                    range: viewModel.dailyRange,
                    icon: "calendar.day.timeline.left"
                )
                
                recommendationRow(
                    id: "weekly",
                    title: appEnv.language.localizedString("khatam_weekly_target"),
                    value: appEnv.language.localizedString("khatam_target_ayahs", arguments: [goal.weeklyTarget]),
                    range: viewModel.weeklyRange,
                    icon: "calendar.badge.clock"
                )
                
                recommendationRow(
                    id: "finish",
                    title: appEnv.language.localizedString("khatam_target_finish"),
                    value: formatDate(goal.targetDate),
                    range: nil,
                    icon: "flag.checkered"
                )
            }
        }
    }
    
    private func recommendationRow(id: String, title: String, value: String, range: String?, icon: String) -> some View {
        let hasDetail = range != nil && !(range?.isEmpty ?? true)
        
        return Button(action: { 
            if hasDetail {
                withAnimation(.spring()) {
                    if expandedRow == id {
                        expandedRow = nil
                    } else {
                        expandedRow = id
                        calculateRanges()
                    }
                }
            }
        }) {
            VStack(spacing: 0) {
                HStack(spacing: AppSpacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .fill(colors.primary.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .foregroundColor(colors.primary)
                            .font(.system(size: 14, weight: .bold))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(TextStyle.caption)
                            .foregroundColor(colors.foreground.opacity(0.6))
                        
                        Text(value)
                            .font(TextStyle.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(colors.foreground)
                    }
                    
                    Spacer()
                    
                    if hasDetail {
                       Image(systemName: expandedRow == id ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.primary.opacity(0.5))
                    }
                }
                .padding(AppSpacing.md)
                
                if expandedRow == id, let range = range, !range.isEmpty {
                    HStack {
                        Text(range)
                            .font(TextStyle.caption)
                            .fontWeight(.medium)
                            .foregroundColor(colors.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(colors.primary.opacity(0.1))
                            .cornerRadius(AppRadius.sm)
                        Spacer()
                    }
                    .padding(.horizontal, 56)
                    .padding(.bottom, AppSpacing.md)
                }
            }
            .background(colors.card)
            .cornerRadius(20)
            .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
        }

        .buttonStyle(PlainButtonStyle())
    }

    
    private func calculateRanges() {
        viewModel.calculateRanges(goal: goal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
