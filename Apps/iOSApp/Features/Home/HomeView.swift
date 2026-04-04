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
        ZStack {
            // MARK: - Background Layer
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - 1. Greet & Integrated Search (Modular)
                    HomeHeaderView(colors: colors)
                    
                    // MARK: - 2. Spiritual Quote (NOW AT THE TOP)
                    HadithWidgetView(colors: colors)
                    
                    // MARK: - 3. Prayer (Modular Widget)
                    PrayerWidgetView(colors: colors, animate: $animateWidget)
                    
                    // MARK: - 4. Feature Grid (Modular)
                    HomeFeatureGrid(colors: colors)
                    
                    // MARK: - 5. Articles Section
                    VStack(alignment: .leading, spacing: 20) {
                        ArticleHeader(colors: colors)
                        
                        VStack(spacing: 16) {
                            HomeArticleCard(
                                colors: colors, 
                                image: "mosque_dawn", 
                                title: appEnv.language.localizedString("home_article_default_title"), 
                                date: "Apr 03, 2026", 
                                description: appEnv.language.localizedString("home_article_default_desc")
                            )
                            HomeArticleCard(
                                colors: colors, 
                                image: "quran_open", 
                                title: appEnv.language.localizedString("home_article_quran_title"), 
                                date: "Apr 01, 2026", 
                                description: appEnv.language.localizedString("home_article_quran_desc")
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 120) // Tab Bar Spacing
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) { animateWidget = true }
        }
    }
}

// MARK: - Internal Component Helper
private struct ArticleHeader: View {
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack {
            Text(appEnv.language.localizedString("home_articles_section"))
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
            Spacer()
            Button(appEnv.language.localizedString("home_articles_all")) { }
                .font(.subheadline.bold())
                .foregroundColor(colors.primary)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeView()
}
