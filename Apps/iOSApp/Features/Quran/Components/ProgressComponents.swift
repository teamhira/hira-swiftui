//
//  ProgressComponents.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct ProgressPieCard: View {
    let progress: Double
    let title: String
    let icon: String
    var isLarge: Bool = false
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.1), lineWidth: isLarge ? 12 : 8)
                Circle()
                    .stroke(colors.primary, style: StrokeStyle(lineWidth: isLarge ? 12 : 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 0) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: isLarge ? 34 : 20, weight: .bold))
                    Text(appEnv.language.localizedString("quran_goal_title"))
                        .font(.system(size: isLarge ? 14 : 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: isLarge ? 150 : 80, height: isLarge ? 150 : 80)
            
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(colors.primary)
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .frame(maxWidth: isLarge ? .infinity : 150)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(16)
        .accessibilityElement(children: .combine)
    }
}

public struct LastReadingCard: View {
    let surah: Surah
    let progress: Double
    @Environment(\.appEnvironment) private var appEnv
    @State private var animatedProgress: Double = 0
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    /// Reverse-calculates the displayed ayah from the progress value.
    private var lastAyah: Int {
        guard surah.versesCount > 1 else { return 1 }
        return max(1, Int((progress * Double(surah.versesCount - 1)).rounded()) + 1)
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                // Label
                Label(appEnv.language.localizedString("quran_last_reading"), systemImage: "bookmark.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(colors.primary)
                
                // Surah name
                Text(surah.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colors.foreground)
                
                // Arabic name
                Text(surah.nameArabic)
                    .font(.custom("KFGQPC Uthman Taha Naskh", size: 18))
                    .foregroundColor(colors.primary.opacity(0.7))
                
                // Ayah progress label
                Text(String(format: appEnv.language.localizedString("quran_ayah_count_label"), lastAyah, surah.versesCount))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
            
            Spacer()
            
            // Pie chart
            ZStack {
                Circle()
                    .stroke(colors.foreground.opacity(0.06), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        LinearGradient(
                            colors: [colors.primary, colors.primary.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 0) {
                    Text("\(Int(animatedProgress * 100))%")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    Text(appEnv.language.localizedString("quran_goal_title"))
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
            }
            .frame(width: 80, height: 80)
        }
        .padding(24)
        .hiraCleanCard(colors: colors, radius: 28)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}
