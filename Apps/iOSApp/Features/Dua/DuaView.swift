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
                        title: "dua_featured_title",
                        description: "dua_featured_desc"
                    )
                    .padding(.top, 16)
                    
                    // Category Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text(LocalizedStringKey("dua_category_title"))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                NavigationLink(value: AppRoute.duaList(category.id)) {
                                    DuaCategoryCard(
                                        category: category.id,
                                        icon: category.icon,
                                        count: viewModel.countForCategory(category.id)
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

// MARK: - Search Results View
struct DuaSearchResultsView: View {
    let viewModel: DuaViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(LocalizedStringKey("home_result_title"))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                let filtered = viewModel.filteredDuasAcrossAll()
                
                if filtered.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchQuery)
                } else {
                    ForEach(filtered) { item in
                        NavigationLink(value: AppRoute.duaDetail(item)) {
                            DuaRow(
                                title: item.title,
                                description: item.description,
                                category: item.category
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Extends ViewModel for Search Result Logic
extension DuaViewModel {
    func filteredDuasAcrossAll() -> [DuaItem] {
        return self.filteredDuas
    }
}

#Preview {
    DuaView()
}
