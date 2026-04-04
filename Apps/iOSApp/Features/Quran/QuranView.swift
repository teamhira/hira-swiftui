//
//  QuranView.swift
//  Hira
//

import SwiftUI

public struct QuranView: View {
    @State private var viewModel = QuranViewModel()
    @Environment(\.appEnvironment) private var appEnv
    
    public init() {}
    
    public var body: some View {
        let colors = appEnv.theme.current
        ZStack(alignment: .bottom) {
            Color(colors.background).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Search & Audio
                QuranHeaderView(searchQuery: $viewModel.searchQuery)
                
                // Top Native Segmented Picker - Only for Surah section
                if viewModel.selectedBottomTab == .surah {
                    QuranTopTabs(selectedTab: $viewModel.selectedTopTab)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Content Switcher using Native TabView
                TabView(selection: $viewModel.selectedBottomTab) {
                    ScrollView(showsIndicators: false) {
                        surahContentView
                            .padding(.bottom, 150)
                    }
                    .tag(QuranBottomTab.surah)
                    
                    ScrollView(showsIndicators: false) {
                        topicContentView
                            .padding(.bottom, 150)
                    }
                    .tag(QuranBottomTab.topic)
                    
                    ScrollView(showsIndicators: false) {
                        dailyContentView
                            .padding(.bottom, 150)
                    }
                    .tag(QuranBottomTab.daily)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            // Custom Floating Tabs overlaying the TabView
            QuranBottomTabs(selectedTab: $viewModel.selectedBottomTab)
        }
    }
    
    @ViewBuilder
    private var surahContentView: some View {
        switch viewModel.selectedTopTab {
        case .surah:
            VStack(spacing: 24) {
                // Redesigned Last Reading Card
                LastReadingCard(surah: viewModel.recentSurah, progress: viewModel.surahProgress)
                    .padding(.horizontal, 24)
                
                // Surah List
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredSurahs) { surah in
                        NavigationLink(value: AppRoute.surahDetail(surah)) {
                            SurahCardView(surah: surah)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
        case .juz:
            VStack(spacing: 24) {
                JuzProgressCard(
                    progress: viewModel.khatamProgress,
                    stats: String(format: appEnv.language.localizedString("quran_juz_khatam_stat"), 3),
                    lastRead: String(format: appEnv.language.localizedString("quran_juz_khatam_last"), "Juz 3 (Ali 'Imran)")
                )
                .padding(.horizontal, 24)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.juzList) { juz in
                        JuzRowView(juz: juz)
                    }
                }
                .padding(.horizontal, 24)
            }
            
        case .bookmark:
            VStack(spacing: 24) {
                BookmarkHeaderCard(
                    count: viewModel.bookmarks.count,
                    lastRead: String(format: appEnv.language.localizedString("quran_bookmark_last"), "Al-Baqarah ayat 255")
                )
                .padding(.horizontal, 24)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.bookmarks) { bookmark in
                        BookmarkRowView(bookmark: bookmark)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    @ViewBuilder
    private var topicContentView: some View {
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
    }
    
    @ViewBuilder
    private var dailyContentView: some View {
        VStack(spacing: 24) {
            // Daily Reminder Header
            HStack(spacing: 12) {
                Image(systemName: "bell.badge.fill")
                    .foregroundColor(appEnv.theme.current.primary)
                    .font(.title3)
                
                Text(appEnv.language.localizedString("quran_daily_reminder_section"))
                    .font(.title3.bold())
                    .foregroundColor(appEnv.theme.current.foreground)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            LazyVStack(spacing: 24) {
                ForEach(viewModel.dailyReminders) { reminder in
                    DailyReminderCard(reminder: reminder)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

#Preview {
    QuranView()
        .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
}
