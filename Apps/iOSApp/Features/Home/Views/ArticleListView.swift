//
//  ArticleListView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct ArticleListView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var searchText = ""
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var filteredArticles: [Article] {
        if searchText.isEmpty {
            return Article.mocks
        }
        return Article.mocks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // MARK: - Featured Articles (Horizontal)
                    if searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Featured Articles")
                                .font(.title3.bold())
                                .foregroundColor(colors.foreground)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(Article.mocks) { article in
                                        FeaturedArticleCard(article: article)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    
                    // MARK: - All Articles (Vertical)
                    VStack(alignment: .leading, spacing: 20) {
                        Text(searchText.isEmpty ? "All Articles" : "Search Results")
                            .font(.title3.bold())
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 16) {
                            ForEach(filteredArticles) { article in
                                HomeArticleCard(colors: colors, article: article)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Articles")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search articles...")
    }
}

private struct FeaturedArticleCard: View {
    let article: Article
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        Button(action: { router.navigate(to: .articleDetail(article)) }) {
            VStack(alignment: .leading, spacing: 12) {
                // Image Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(colors.primary.opacity(0.1))
                        .frame(width: 280, height: 180)
                    
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(colors.primary.opacity(0.3))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.category.uppercased())
                        .font(.caption2.bold())
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(colors.primary.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text(article.title)
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(article.readTime)
                            .font(.caption2)
                        
                        Text("•")
                        
                        Text(article.date)
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 4)
            }
            .frame(width: 280)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        ArticleListView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
            .environment(AppRouter())
    }
}
