//
//  QuranTopicTabView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct QuranTopicTabView: View {
    let viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // MARK: - Stories Section
                VStack(spacing: 16) {
                    SectionHeaderView(title: appEnv.language.localizedString("quran_stories_section"), icon: "book")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.stories) { story in
                                StoryCardView(story: story)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                // MARK: - Topics Section
                VStack(spacing: 16) {
                    SectionHeaderView(title: appEnv.language.localizedString("quran_topics_section"), icon: "doc.plaintext")
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.topics) { topic in
                            TopicCardView(topic: topic)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 120) // Accounting for the floating bottom tabs
            }
            .padding(.top, 16)
            .padding(.bottom, 150)
        }
    }
}
