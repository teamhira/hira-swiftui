//
//  CharityCauseCard.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct CharityCauseCard: View {
    let title: String
    let description: String
    let image: String
    let raised: Int
    let target: Int
    let progress: Double
    let donors: Int
    let days: Int
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Area
            ZStack(alignment: .topLeading) {
                UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                    .fill(colors.primary.opacity(0.1))
                    .frame(height: 160)
                
                Image(systemName: image)
                    .font(.system(size: 50))
                    .foregroundColor(colors.primary.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: 160)
                
                HStack(spacing: 8) {
                    Text(appEnv.language.localizedString("charity_urgent_badge"))
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    
                    Text(appEnv.language.localizedString("charity_category_education"))
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                .padding(16)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                Text(title)
                    .font(.headline.bold())
                    .lineLimit(1)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                VStack(spacing: 6) {
                    HStack {
                        Text(appEnv.language.localizedString("charity_raised_of", defaultValue: "$\(raised) of $\(target)"))
                            .font(.subheadline.bold())
                            .foregroundColor(colors.primary)
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.caption.bold())
                            .foregroundColor(colors.primary)
                    }
                    
                    ProgressView(value: progress)
                        .tint(colors.primary)
                        .frame(height: 6)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 10) {
                    StatBadge(icon: "person.2.fill", text: String(format: appEnv.language.localizedString("charity_donors_count"), donors))
                    StatBadge(icon: "calendar", text: String(format: appEnv.language.localizedString("charity_days_count"), days))
                    Spacer()
                    Text(String(format: appEnv.language.localizedString("charity_target_label"), "\(target/1000)"))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                }
                
                Button(action: {}) {
                    Text(appEnv.language.localizedString("charity_donate_now_button"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(colors.primary)
                        .cornerRadius(12)
                }
                .accessibilityLabel(String(format: appEnv.language.localizedString("charity_accessibility_donate_button"), title))

            }
            .padding(20)
        }
        .hiraCleanCard(colors: colors, radius: 24)
    }
    
    private func StatBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundColor(.secondary)
    }
}
