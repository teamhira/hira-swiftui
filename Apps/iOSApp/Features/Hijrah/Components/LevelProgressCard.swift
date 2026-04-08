//
//  LevelProgressCard.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct LevelProgressCard: View {
    @Environment(\.appEnvironment) private var appEnv
    
    let level: Int
    let levelName: String
    let xp: Int
    let streak: Int
    let progress: Double
    let colors: ThemeModel
    
    // Detailed tier info derived from level
    private var subIndex: Int { (level - 1) % 10 }
    
    private var tierInfo: (name: String, roman: String, colorHex: String) {
        IslamicLevel.getLevelTierInfo(for: level)
    }
    
    private var tierColor: Color {
        Color(hex: tierInfo.colorHex)
    }
    
    var body: some View {
        VStack(spacing: 28) {
            // Header: Level & Tier Badge
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        // SPIRITUAL TIER BADGE
                        HStack(spacing: 6) {
                            Text(tierInfo.name)
                                .font(.system(size: 11, weight: .black))
                                .textCase(.uppercase)
                            Text(tierInfo.roman)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(tierColor)
                                .shadow(color: tierColor.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                        
                        Text(levelName)
                            .font(.title2.bold())
                            .foregroundColor(colors.foreground)
                    }
                    
                    HStack(spacing: 8) {
                        Text(String(format: appEnv.language.localizedString("hijrah_dash_level"), level))
                            .font(.subheadline.bold())
                            .foregroundColor(colors.primary)
                        
                        Text("•")
                            .foregroundColor(colors.foreground.opacity(0.2))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                            Text("\(streak) hari")
                                .font(.caption.bold())
                                .foregroundColor(colors.foreground.opacity(0.6))
                        }
                    }
                }
                Spacer()
                
                // Circular Progress (XP)
                XPIndicator(xp: xp, colors: colors)
            }
            
            // 3/3/3 Segmented Progress Bar
            VStack(spacing: 16) {
                HStack {
                    Text("Pencapaian Spiritual")
                        .font(.caption2.bold())
                        .foregroundColor(colors.foreground.opacity(0.4))
                        .textCase(.uppercase)
                    Spacer()
                    Text("\(min(subIndex + 1, 10))/10")
                        .font(.caption2.bold())
                        .foregroundColor(tierColor)
                }
                
                HStack(spacing: 8) {
                    // Segment Group: BIDAYAH (1-3)
                    tierSegmentGroup(startIndex: 0, activeIndex: subIndex, color: Color(hex: "#CD7F32"))
                    
                    // Segment Group: WASATHIYAH (4-6)
                    tierSegmentGroup(startIndex: 3, activeIndex: subIndex, color: Color(hex: "#C0C0C0"))
                    
                    // Segment Group: IHSAN (7-10)
                    tierSegmentGroup(startIndex: 6, activeIndex: subIndex, color: Color(hex: "#FFD700"))
                }
                
                // Islamic Tier Labels
                HStack(spacing: 0) {
                    tierLabel("BIDAYAH", active: subIndex < 3, alignment: .leading)
                    tierLabel("WASATHIYAH", active: subIndex >= 3 && subIndex < 6, alignment: .center)
                    tierLabel("IHSAN", active: subIndex >= 6, alignment: .trailing)
                }
            }
        }
        .padding(24)
        .hiraCleanCard(colors: colors, radius: 32)
    }
    
    private func tierSegmentGroup(startIndex: Int, activeIndex: Int, color: Color) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                let idx = startIndex + i
                Capsule()
                    .fill(idx <= activeIndex ? color : colors.foreground.opacity(0.05))
                    .frame(height: 8)
                    .overlay(
                        Group {
                            if idx == activeIndex {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 4, height: 4)
                            }
                        }
                    )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func tierLabel(_ text: String, active: Bool, alignment: TextAlignment) -> some View {
        Text(text)
            .font(.system(size: 8, weight: .black))
            .foregroundColor(active ? colors.foreground : colors.foreground.opacity(0.15))
            .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : (alignment == .trailing ? .trailing : .center))
    }
}

// Separate component for clarity
private struct XPIndicator: View {
    let xp: Int
    let colors: ThemeModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(colors.primary.opacity(0.05), lineWidth: 6)
                .frame(width: 68, height: 68)
            Circle()
                .trim(from: 0, to: CGFloat(xp) / 100.0)
                .stroke(
                    colors.primary,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 68, height: 68)
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 0) {
                Text("\(xp)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(colors.foreground)
                Text("XP")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
    }
}
