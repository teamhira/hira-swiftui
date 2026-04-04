//
//  GlobalSearchView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct GlobalSearchView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var searchText = ""
    @State private var isSearching = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack(alignment: .top) {
            colors.background.ignoresSafeArea()
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // MARK: - Suggested Section
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: appEnv.language.localizedString("search_suggested_title"), icon: "sparkles")
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                SuggestionChip(title: appEnv.language.localizedString("quran_daily_reminder"))
                                SuggestionChip(title: appEnv.language.localizedString("home_feature_qibla"))
                                SuggestionChip(title: appEnv.language.localizedString("explore_category_halal"))
                                SuggestionChip(title: appEnv.language.localizedString("quran_tab_topic"))
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    // MARK: - Daily Deen Section
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: appEnv.language.localizedString("search_daily_deen_title"), icon: "alarm")
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_prayer_times"), icon: "clock.fill", color: colors.primary)
                                .onTapGesture { withAnimation { isSearching = true } }
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_quran"), icon: "book.fill", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_duas"), icon: "heart.fill", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_qibla"), icon: "location.fill", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_khatam"), icon: "arrow.clockwise", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_deen_mode"), icon: "moon.fill", color: colors.primary)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Spiritual Journey Section
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: appEnv.language.localizedString("search_spiritual_journey_title"), icon: "safari.fill")
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_goals"), icon: "target", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_tracker"), icon: "chart.line.uptrend.xyaxis", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_achievements"), icon: "medal.fill", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_learning"), icon: "book.closed.fill", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_good_deeds"), icon: "heart.circle.fill", color: colors.primary)
                            SearchGridItem(title: appEnv.language.localizedString("search_feature_spiritual_level"), icon: "star.fill", color: colors.primary)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 110) // Consistent spacing for custom header
            }
            
            // MARK: - Custom Glass Header
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    // Back Button (Native Look + Glass)
                    Button(action: { router.pop() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(colors.foreground)
                            .frame(width: 44, height: 44)
                            .background(
                                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(colors.foreground.opacity(0.05), lineWidth: 0.5))
                            )
                    }
                    
                    // Morphing Search Bar
                    HStack(spacing: 0) {
                    if !isSearching {
                        Text(appEnv.language.localizedString("search_placeholder_short"))
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
                                TextField(appEnv.language.localizedString("search_placeholder_long"), text: $searchText)
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
                .padding(.horizontal, 20)
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
        .navigationBarHidden(true)
    }
}

// MARK: - Supporting Views
private struct SectionHeader: View {
    let title: String
    let icon: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(colors.primary)
            Text(title)
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
        }
    }
}

private struct SuggestionChip: View {
    let title: String
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Text(title)
            .font(.subheadline.bold())
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(colors.primary.opacity(0.1))
            .foregroundColor(colors.primary)
            .clipShape(Capsule())
    }
}

private struct SearchGridItem: View {
    let title: String
    let icon: String
    let color: Color
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(colors.foreground)
                .lineLimit(2)
            
            Spacer()
            
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(colors.primary.opacity(0.6))
        }
        .padding(AppSpacing.lg)
        .frame(height: 90)
        .hiraCleanCard(colors: colors, radius: 20)
    }
}

#Preview {
    NavigationStack {
        GlobalSearchView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
