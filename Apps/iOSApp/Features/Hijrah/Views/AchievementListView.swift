//
//  AchievementListView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct AchievementListView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    let achievements: [Achievement]
    let colors: ThemeModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @State private var selectedAchievement: Achievement? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header Stats
                    HStack(spacing: 24) {
                        statItem(title: "\(achievements.count)", sub: "Terbuka", icon: "lock.open.fill")
                        statItem(title: "12", sub: "Terkunci", icon: "lock.fill")
                        statItem(title: "750", sub: "XP", icon: "sparkles")
                    }
                    .padding(24)
                    .hiraCleanCard(colors: colors, radius: 28)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Daftar Pencapaian")
                            .font(.title3.bold())
                            .foregroundColor(colors.foreground)
                        
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(achievements) { ach in
                                Button(action: { selectedAchievement = ach }) {
                                    AchievementBadge(icon: ach.icon, label: ach.title, colors: colors)
                                }
                            }
                            
                            // Placeholders for locked ones
                            ForEach(0..<6) { _ in
                                lockedBadge
                            }
                        }
                    }
                }
                .padding(24)
            }
            .background(colors.background)
            .navigationTitle("Pencapaian")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(colors.foreground.opacity(0.5))
                    }
                }
            }
            .sheet(item: $selectedAchievement) { ach in
                AchievementDetailSheet(achievement: ach, colors: colors, appEnv: appEnv)
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func statItem(title: String, sub: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(colors.primary)
            Text(title)
                .font(.headline.bold())
            Text(sub)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var lockedBadge: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colors.foreground.opacity(0.03))
                    .frame(width: 64, height: 64)
                
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.1))
            }
            
            Text("???")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.1))
        }
        .frame(width: 80)
    }
}
