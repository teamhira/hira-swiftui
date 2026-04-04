//
//  ReelCard.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct ReelCard: View {
    let reel: ExploreReel
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(colors.foreground.opacity(0.05))
                .frame(width: 160, height: 260)
                .overlay(
                    LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                )
            
            // Duration Tag
            Text(reel.duration)
                .font(.caption2.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark).clipShape(Capsule()))
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            // Play Icon
            Image(systemName: "play.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Circle().fill(.white.opacity(0.3)))
                .blur(radius: 0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reel.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                Text(reel.subtitle)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
            .padding(AppSpacing.md)
        }
        .shadow(color: colors.foreground.opacity(0.05), radius: 10, x: 0, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(reel.title), duration \(reel.duration)")
    }
}
