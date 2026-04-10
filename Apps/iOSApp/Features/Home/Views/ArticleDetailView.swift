//
//  ArticleDetailView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Hero Image Area
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(colors.primary.opacity(0.1))
                        .frame(height: 350)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(article.category.uppercased())
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(colors.primary)
                            .cornerRadius(8)
                        
                        Text(article.title)
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(colors.foreground)
                            .shadow(color: colors.background.opacity(0.8), radius: 2)
                    }
                    .padding(24)
                }
                
                // MARK: - Content Area
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Author & Meta Info
                    HStack(spacing: 16) {
                        Circle()
                            .fill(colors.primary.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(article.author.prefix(1))
                                    .font(.headline)
                                    .foregroundColor(colors.primary)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(article.author)
                                .font(.subheadline.bold())
                                .foregroundColor(colors.foreground)
                            
                            Text("\(article.date) • \(article.readTime)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { /* Share action */ }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(colors.primary)
                                .padding(10)
                                .background(Circle().fill(colors.primary.opacity(0.1)))
                        }
                    }
                    .padding(.top, 24)
                    
                    Divider()
                    
                    // Article Content
                    Text(article.content)
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .lineSpacing(8)
                        .foregroundColor(colors.foreground.opacity(0.9))
                    
                    // Quote Block Style Example
                    VStack(alignment: .leading, spacing: 12) {
                        Rectangle()
                            .fill(colors.primary)
                            .frame(width: 40, height: 4)
                        
                        Text("Knowledge is the life of the mind.")
                            .font(.title3.italic())
                            .foregroundColor(colors.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(24)
                    .background(colors.primary.opacity(0.05))
                    .cornerRadius(16)
                    
                    // Continued Content
                    Text("The importance of continuous learning in Islam cannot be overstated. From the first word of revelation, 'Iqra' (Read), our faith has centered around the pursuit of knowledge and understanding.")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .lineSpacing(8)
                        .foregroundColor(colors.foreground.opacity(0.9))
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 24)
                .background(colors.background)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .offset(y: -30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { /* Bookmark action */ }) {
                    Image(systemName: "bookmark")
                        .foregroundColor(colors.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(article: Article.mocks[0])
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
