//
//  StoryComponents.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct StoryCardView: View {
    let story: QuranStory
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colors.primary.opacity(0.1))
                    .frame(height: 160)
                    .overlay(Image(systemName: "photo").font(.title2).foregroundColor(colors.primary.opacity(0.3)))
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 14, weight: .bold))
                        .padding(8)
                        .background(.ultraThinMaterial).clipShape(Circle()).padding(12)
                }
                .foregroundColor(colors.foreground)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(story.title).font(.subheadline.bold())
                Text(story.description).font(.caption).foregroundColor(colors.foreground.opacity(0.6)).lineLimit(2)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 260)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(colors.background))
        .shadow(color: colors.foreground.opacity(0.03), radius: 15, x: 0, y: 10)
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
    }
}

public struct TopicCardView: View {
    let topic: QuranTopic
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 60, height: 60)
                Image(systemName: "photo").font(.caption).foregroundColor(colors.primary.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title).font(.system(size: 14, weight: .bold))
                Text(String(format: appEnv.language.localizedString("quran_topic_stories_count"), topic.storyCount))
                    .font(.system(size: 10, weight: .bold))
                    .padding(.vertical, 4).padding(.horizontal, 10).background(colors.primary.opacity(0.1)).cornerRadius(12).foregroundColor(colors.primary)
            }
            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(colors.background))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
    }
}
