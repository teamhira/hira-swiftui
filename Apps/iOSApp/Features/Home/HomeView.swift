//
//  HomeView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct HomeView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var animateWidget = false
    
    private var theme: ThemeManager { appEnv.theme }
    private var colors: ThemeModel { theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Background Layer
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - 1. Greet (Will scroll away)
                    GreetingRow(colors: colors)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .opacity(1.0 - min(1.0, max(0.0, -scrollOffset / 50)))
                    
                    // MARK: - 2. Spacer for Sticky Search
                    // This creates space where the sticky search bar will initially sit
                    Color.clear.frame(height: 54)
                    
                    // MARK: - 3. Content Sections
                    Group {
                        HadithWidgetView(colors: colors)
                        
                        PrayerWidgetView(colors: colors, animate: $animateWidget)
                        
                        HomeFeatureGrid(colors: colors)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            ArticleHeader(colors: colors)
                            
                            VStack(spacing: 16) {
                                ForEach(Article.mocks.prefix(2)) { article in
                                    HomeArticleCard(colors: colors, article: article)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer(minLength: 120)
                }
                .background(
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .named("HOME_SCROLL")).minY
                        Color.clear
                            .onAppear { scrollOffset = minY }
                            .onChange(of: minY) { _, new in
                                scrollOffset = new
                            }
                    }
                )
            }
            .coordinateSpace(name: "HOME_SCROLL")
            
            // MARK: - Pinned Search Bar
            VStack(spacing: 0) {
                let searchInitialY: CGFloat = 85 // Approximately where it sits after Greeting
                let stickyThreshold: CGFloat = searchInitialY
                let currentOffset = -scrollOffset
                
                SearchBar(colors: colors)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(colors.background.opacity(currentOffset > stickyThreshold ? 0.95 : 0))
                    .offset(y: max(stickyThreshold - currentOffset, 0))
                    .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: scrollOffset)
                
                if currentOffset > stickyThreshold {
                    Divider().transition(.opacity)
                }
            }
            .background(colors.background.opacity(min(1.0, max(0.0, (-scrollOffset - 85) / 20))).ignoresSafeArea())
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) { animateWidget = true }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @State private var scrollOffset: CGFloat = 0
}

// MARK: - Internal Component Helper
private struct ArticleHeader: View {
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        HStack {
            Text(appEnv.language.localizedString("home_articles_section"))
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
            Spacer()
            Button(appEnv.language.localizedString("home_articles_all")) {
                router.navigate(to: .articleList)
            }
                .font(.subheadline.bold())
                .foregroundColor(colors.primary)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(AppRouter())
            .environment(AppState())
    }
}
