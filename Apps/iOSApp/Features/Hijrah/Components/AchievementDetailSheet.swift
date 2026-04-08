//
//  AchievementDetailSheet.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct AchievementDetailSheet: View {
    let achievement: Achievement
    let colors: ThemeModel
    let appEnv: AppEnvironment
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: 1. Header Section (Visual Showcase)
                    ZStack {
                        // Ambient background glow
                        LinearGradient(
                            colors: [colors.primary.opacity(0.1), colors.background],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 380)
                        
                        VStack(spacing: 28) {
                            // The Badge/Trophy
                            ZStack {
                                // Animated ring
                                Circle()
                                    .stroke(colors.primary.opacity(0.1), lineWidth: 2)
                                    .frame(width: 160, height: 160)
                                
                                Circle()
                                    .fill(colors.background)
                                    .frame(width: 130, height: 130)
                                    .shadow(color: colors.primary.opacity(0.2), radius: 25, x: 0, y: 12)
                                
                                Image(systemName: achievement.icon)
                                    .font(.system(size: 54, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [colors.primary, colors.primary.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .symbolRenderingMode(.hierarchical)
                                
                                if achievement.isLocked {
                                    Circle()
                                        .fill(colors.background.opacity(0.8))
                                        .frame(width: 130, height: 130)
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.title)
                                        .foregroundColor(colors.primary.opacity(0.3))
                                }
                            }
                            .padding(.top, 60)
                            
                            VStack(spacing: 8) {
                                Text(achievement.title)
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(colors.foreground)
                                    .multilineTextAlignment(.center)
                                
                                Text(appEnv.language.localizedString("achievement_detail_type"))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(colors.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(colors.primary.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    
                    // MARK: 2. Content Section
                    VStack(spacing: 32) {
                        // Description
                        Text(achievement.description)
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundColor(colors.foreground.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 32)
                        
                        // Details Grid/List
                        VStack(spacing: 0) {
                            detailRow(
                                icon: "bolt.fill",
                                label: appEnv.language.localizedString("achievement_reward_label"),
                                value: "\(achievement.xp) XP",
                                color: colors.primary
                            )
                            
                            detailRow(
                                icon: "tag.fill",
                                label: appEnv.language.localizedString("achievement_category_label"),
                                value: appEnv.language.localizedString("achievement_cat_\(achievement.category.lowercased())"),
                                color: colors.foreground.opacity(0.6)
                            )
                        }
                        .padding(8)
                        .background(colors.foreground.opacity(0.03))
                        .cornerRadius(24)
                        .padding(.horizontal, 24)
                        
                        // MARK: 3. Share Button
                        if !achievement.isLocked {
                            Button(action: { showingRiyaAlert = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "square.and.arrow.up.fill")
                                    Text(appEnv.language.localizedString("achievement_button_share"))
                                }
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(colors.primary)
                                .cornerRadius(20)
                                .shadow(color: colors.primary.opacity(0.3), radius: 15, x: 0, y: 8)
                            }
                            .padding(.horizontal, 24)
                        } else {
                            // Locked Hint
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                Text("Lengkapi misi untuk membuka pencapaian ini")
                            }
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 140)
                }
            }
            
            // Fixed Close Button at bottom
            VStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(colors.foreground.opacity(0.4))
                        .padding(12)
                        .background(Circle().fill(colors.foreground.opacity(0.05)))
                }
                .padding(.bottom, 40)
            }
        }
        .alert(appEnv.language.localizedString("achievement_share_warning_title"), isPresented: $showingRiyaAlert) {
            Button(appEnv.language.localizedString("accessibility_button_cancel"), role: .cancel) { }
            Button(appEnv.language.localizedString("common_confirm_share")) {
                shareAchievement()
            }
        } message: {
            Text(appEnv.language.localizedString("achievement_share_warning_message"))
        }
    }
    
    private func detailRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(colors.foreground.opacity(0.6))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(colors.foreground)
        }
        .padding(16)
    }
    
    @State private var showingRiyaAlert = false
    
    private func shareAchievement() {
        let text = "Alhamdulillah! I've earned the '\(achievement.title)' achievement in Hira app. 🌟\n\n\(achievement.description)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
