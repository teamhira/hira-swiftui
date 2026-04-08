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
                    FeaturedHadithView(
                        title: viewModel.featuredHadith.title,
                        bodyText: viewModel.featuredHadith.body,
                        source: viewModel.featuredHadith.source
                    )
                    .padding(.top, 16)
                    
                    // Popular Collections Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("hadith_collection_title"))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(viewModel.collections) { collection in
                                Button(action: {
                                    router.navigate(to: .hadithList(collection.id))
                                }) {
                                    HadithCollectionCard(
                                        title: collection.id,
                                        icon: collection.icon,
                                        count: collection.count
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 32)
            }
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
                    
                    let filtered = viewModel.searchHadiths()
                    
                    if filtered.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchQuery)
                            .padding(.top, 40)
                    } else {
                        ForEach(filtered) { item in
                            Button(action: {
                                router.navigate(to: .hadithDetail(item))
                            }) {
                                HadithRow(
                                    title: item.title,
                                    bodyText: item.body,
                                    narrator: item.narrator,
                                    source: item.source
                                )
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
