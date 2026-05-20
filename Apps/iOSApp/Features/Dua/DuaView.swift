//
//  DuaView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DuaView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var viewModel = DuaViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Featured Section
                    FeaturedDuaView(
                        item: viewModel.featuredDua,
                        isLoading: viewModel.isFeaturedLoading
                    )
                    .padding(.top, 16)
                    
                    // Category Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text(LocalizedStringKey("dua_category_title"))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        if viewModel.isCategoriesLoading {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(0..<6, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(colors.foreground.opacity(0.05))
                                        .frame(height: 120)
                                        .hiraShimmer()
                                }
                            }
                            .padding(.horizontal, 24)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(viewModel.categories) { category in
                                    NavigationLink(value: AppRoute.duaList(category.id)) {
                                        DuaCategoryCard(
                                            category: category,
                                            icon: viewModel.getIconForCategory(category.id)
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
        // MARK: - Configuration
        .navigationTitle(LocalizedStringKey("home_feature_dua"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchQuery, prompt: LocalizedStringKey("dua_search_placeholder"))
        .overlay {
            if !viewModel.searchQuery.isEmpty {
                DuaSearchResultsView(viewModel: viewModel)
            }
        }
    }
}

struct DuaSearchResultsView: View {
    let viewModel: DuaViewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedStringKey("home_result_title"))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    if viewModel.isSearching {
                        VStack(spacing: 16) {
                            ForEach(0..<3, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(colors.foreground.opacity(0.05))
                                    .frame(height: 100)
                                    .hiraShimmer()
                            }
                        }
                        .padding(.horizontal, 24)
                    } else if viewModel.searchResults.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchQuery)
                            .padding(.top, 40)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewModel.searchResults) { item in
                                Button(action: {
                                    router.navigate(to: .duaDetail(item))
                                }) {
                                    DuaRow(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}


#Preview {
    DuaView()
}
