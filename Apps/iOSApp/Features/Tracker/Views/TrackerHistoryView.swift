//
//  TrackerHistoryView.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct TrackerHistoryView: View {
    let history: [TrackerDayHistory]
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            if history.isEmpty {
                emptyHistoryView()
            } else {
                ScrollView {
                    LazyVStack(spacing: AppSpacing.md) {
                        ForEach(history) { day in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(formatDate(day.dateString))
                                        .font(.headline.bold())
                                        .foregroundColor(colors.foreground)
                                    
                                    Text("\(Int(day.completionRate * 100))% Completed")
                                        .font(.caption)
                                        .foregroundColor(colors.foreground.opacity(0.5))
                                }
                                
                                Spacer()
                                
                                // Progress Bar
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(colors.foreground.opacity(0.05))
                                        .frame(width: 100, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(colors.primary)
                                        .frame(width: 100 * day.completionRate, height: 8)
                                }
                            }
                            .padding()
                            .background(colors.card)
                            .cornerRadius(16)
                            .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
        }
        .navigationTitle(appEnv.language.localizedString("tracker_history_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func emptyHistoryView() -> some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 48))
                .foregroundColor(colors.primary.opacity(0.2))
            
            Text(appEnv.language.localizedString("tracker_history_empty"))
                .font(TextStyle.caption)
                .foregroundColor(colors.foreground.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        return displayFormatter.string(from: date)
    }
}
