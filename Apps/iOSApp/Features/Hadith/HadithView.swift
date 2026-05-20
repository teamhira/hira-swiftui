//
//  HadithView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HadithView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var viewModel = HadithViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Featured Hadith Section
                    if let featured = viewModel.featuredHadith {
                        FeaturedHadithView(item: featured)
                            .padding(.top, 16)
                    } else if viewModel.isLoading {
                        // Loading Placeholder
                        RoundedRectangle(cornerRadius: 32)
                            .fill(colors.primary.opacity(0.05))
                            .frame(height: 200)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .hiraShimmer()
                    }
                    
                    // Popular Collections Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("hadith_collection_title"))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        if viewModel.isLoading && viewModel.collections.isEmpty {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(0..<4, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(colors.background)
                                        .frame(height: 140)
                                        .hiraCleanCard(colors: colors)
                                        .hiraShimmer()
                                }
                            }
                            .padding(.horizontal, 24)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(viewModel.collections) { collection in
                                    Button(action: {
                                        router.navigate(to: .hadithList(collection.key))
                                    }) {
                                        HadithCollectionCard(
                                            collection: collection,
                                            icon: viewModel.getIcon(for: collection.key)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .task {
            viewModel.fetchInitialData()
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_hadith"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchQuery, prompt: appEnv.language.localizedString("dua_search_placeholder")) // Recycled key
        .overlay {
            if !viewModel.searchQuery.isEmpty {
                HadithSearchResultsView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Search Results View
struct HadithSearchResultsView: View {
    let viewModel: HadithViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(appEnv.language.localizedString("home_result_title"))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    if viewModel.isLoading {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 24)
                                .fill(colors.background)
                                .frame(height: 100)
                                .padding(.horizontal, 24)
                                .hiraShimmer()
                        }
                    } else if viewModel.searchResults.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchQuery)
                            .padding(.top, 40)
                    } else {
                        ForEach(viewModel.searchResults) { item in
                            Button(action: {
                                router.navigate(to: .hadithDetail(item))
                            }) {
                                HadithRow(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HadithView()
    }
}
