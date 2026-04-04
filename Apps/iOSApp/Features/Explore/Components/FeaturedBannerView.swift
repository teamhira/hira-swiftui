//
//  FeaturedBannerView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct FeaturedBannerView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(LinearGradient(colors: [colors.primary, colors.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 280)
                    .overlay(
                        Image(systemName: "moon.stars.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .foregroundColor(.white.opacity(0.1))
                            .offset(x: 100, y: -50)
                    )
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "moon.fill")
                            .font(.caption2)
                        Text(appEnv.language.localizedString("explore_featured_tag"))
                            .font(.caption2.bold())
                            .textCase(.uppercase)
                    }
                    .foregroundColor(.white.opacity(0.8))
                    
                    Text(appEnv.language.localizedString("explore_featured_title"))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(appEnv.language.localizedString("explore_featured_desc"))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(3)
                        .padding(.bottom, 8)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text(appEnv.language.localizedString("explore_featured_button"))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(.white))
                    }
                }
                .padding(24)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .shadow(color: colors.foreground.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
