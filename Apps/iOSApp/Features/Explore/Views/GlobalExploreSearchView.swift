//
//  GlobalExploreSearchView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

//
//  GlobalExploreSearchView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct GlobalExploreSearchView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var searchText = ""
    @State private var isSearching = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // MARK: - Suggested for You
                    SectionCard(
                        title: appEnv.language.localizedString("explore_search_suggested_title"),
                        icon: "lightbulb.fill",
                        badge: appEnv.language.localizedString("explore_search_personalized"),
                        badgeIcon: "sparkles"
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                SuggestedCard(
                                    title: appEnv.language.localizedString("explore_search_item_morning_guide"),
                                    category: appEnv.language.localizedString("explore_search_guide"),
                                    badge: appEnv.language.localizedString("explore_search_badge_high"),
                                    tags: [appEnv.language.localizedString("explore_search_worship"), appEnv.language.localizedString("explore_search_recommended")]
                                )
                                SuggestedCard(
                                    title: appEnv.language.localizedString("explore_search_item_quran_tips"),
                                    category: appEnv.language.localizedString("explore_search_tips"),
                                    badge: nil,
                                    tags: [appEnv.language.localizedString("explore_search_learning"), appEnv.language.localizedString("explore_search_recommended")]
                                )
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 4) // Prevents card clipping
                        }
                    }
                    
                    // MARK: - Hot Reels
                    SectionCard(
                        title: appEnv.language.localizedString("explore_search_reels_title"),
                        icon: "play.circle.fill",
                        badge: appEnv.language.localizedString("explore_search_popular"),
                        badgeIcon: "flame.fill"
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ReelCard(reel: ExploreReel(
                                    title: appEnv.language.localizedString("explore_search_item_recitation"),
                                    subtitle: appEnv.language.localizedString("explore_search_item_recitation_desc"),
                                    duration: "3:45",
                                    imageName: "explore_reel_quran_recitation_1775291338028"
                                ))
                                
                                ReelCard(reel: ExploreReel(
                                    title: appEnv.language.localizedString("explore_search_item_dhikr"),
                                    subtitle: appEnv.language.localizedString("explore_search_item_dhikr_desc"),
                                    duration: "1:30",
                                    imageName: "explore_dhikr_reminder_thumb_1775291365907"
                                ))
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8) // Prevents shadow clipping and ensures full visibility
                        }
                    }
                    
                    // MARK: - Top Articles
                    SectionCard(
                        title: appEnv.language.localizedString("explore_search_articles_title"),
                        icon: "doc.text.fill",
                        badge: appEnv.language.localizedString("explore_search_trending"),
                        badgeIcon: "chart.line.uptrend.xyaxis"
                    ) {
                        VStack(spacing: 16) {
                            ArticleRow(
                                title: appEnv.language.localizedString("explore_search_item_fatiha"),
                                category: appEnv.language.localizedString("explore_search_tafsir"),
                                views: String(format: appEnv.language.localizedString("explore_search_item_views"), "12.5K")
                            )
                            ArticleRow(
                                title: appEnv.language.localizedString("explore_search_item_charity"),
                                category: appEnv.language.localizedString("explore_search_worship"),
                                views: String(format: appEnv.language.localizedString("explore_search_item_views"), "8.2K")
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 4) // Prevents row clipping
                    }
                    
                    Spacer(minLength: 120) // Bottom safety
                }
                .padding(.top, 110) // Consistent with Charity
            }
            
            headerSection
        }
        .navigationBarHidden(true)
    }
    
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Back Button (Consistent with Charity)
                Button(action: { router.pop() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.foreground)
                        .frame(width: 44, height: 44)
                        .background(
                            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(colors.foreground.opacity(0.1), lineWidth: 0.5))
                        )
                }
                .accessibilityLabel(appEnv.language.localizedString("explore_search_accessibility_back"))
                
                // Unified Morphing Search Bar
                HStack(spacing: 0) {
                    if !isSearching {
                        Text(appEnv.language.localizedString("tab_explore"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                        Spacer()
                    }
                    
                    HStack(spacing: isSearching ? 12 : 0) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isSearching ? .secondary : colors.primary)
                        
                        if isSearching {
                            TextField(appEnv.language.localizedString("explore_search_placeholder"), text: $searchText)
                                .font(.subheadline)
                                .submitLabel(.search)
                                .transition(.opacity)
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, isSearching ? 16 : 0)
                    .frame(height: 48)
                    .frame(maxWidth: isSearching ? .infinity : 48)
                    .background(
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                            .background(isSearching ? Color.clear : colors.primary.opacity(0.05))
                            .cornerRadius(24)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(colors.foreground.opacity(0.1), lineWidth: 0.5)
                            .opacity(isSearching ? 1 : 0)
                    )
                    .onTapGesture {
                        if !isSearching {
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                                isSearching = true
                            }
                        }
                    }
                    
                    if isSearching {
                        Button(action: {
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                                isSearching = false
                                searchText = ""
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(colors.foreground)
                                .frame(width: 32, height: 32)
                                .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial).clipShape(Circle()))
                                .overlay(Circle().stroke(colors.foreground.opacity(0.1), lineWidth: 0.5))
                        }
                        .padding(.leading, 12)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .padding(.top, 10)
            .background(
                VisualEffectBlur(blurStyle: .systemChromeMaterial)
                    .ignoresSafeArea(edges: .top)
                    .overlay(
                        VStack {
                            Spacer()
                            Divider().opacity(0.5)
                        }
                    )
            )
        }
    }
}

// MARK: - Components

private struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    let badge: String?
    let badgeIcon: String?
    let content: () -> Content
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .foregroundColor(colors.primary)
                        .font(.headline)
                    Text(title)
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                }
                .accessibilityAddTraits(.isHeader)
                
                Spacer()
                
                if let badge = badge, let badgeIcon = badgeIcon {
                    HStack(spacing: 6) {
                        Image(systemName: badgeIcon)
                            .font(.system(size: 10, weight: .bold))
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(colors.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(colors.accent.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 24)
            
            content()
        }
    }
}

private struct SuggestedCard: View {
    let title: String
    let category: String
    let badge: String?
    let tags: [String]
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Spacer()
                
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            
            Text(category)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            HStack(spacing: 12) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding(20)
        .frame(width: 200, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(colors.primary.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("explore_search_accessibility_content"), title, category))
        .accessibilityAddTraits(.isButton)
    }
}

private struct ArticleRow: View {
    let title: String
    let category: String
    let views: String
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                
                HStack(spacing: 12) {
                    Text(category)
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(views)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary)
        }
        .padding(16)
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("explore_search_accessibility_article"), title, category, views))
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    GlobalExploreSearchView()
        .environment(AppRouter())
        .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
}
