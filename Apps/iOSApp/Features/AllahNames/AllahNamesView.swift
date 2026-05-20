//
//  AllahNamesView.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI

struct AllahNamesView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var viewModel = AllahNamesViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Daily Recitation / Featured
                    if let daily = viewModel.dailyName {
                        NavigationLink(destination: AllahNameDetailView(item: daily)) {
                            DailyNameCard(item: daily)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, 16)
                    } else if viewModel.isLoading {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(colors.primary.opacity(0.05))
                            .frame(height: 240)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .hiraShimmer()
                    }
                    
                    // All Names Section
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text(appEnv.language.localizedString("allahnames_list_title"))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                            
                            Spacer()
                            
                            NavigationLink(destination: AllahNamesListView(names: viewModel.allNames)) {
                                Text(appEnv.language.localizedString("common_see_all"))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(colors.primary)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        if viewModel.isLoading && viewModel.allNames.isEmpty {
                            VStack(spacing: 16) {
                                ForEach(0..<4, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(colors.background)
                                        .frame(height: 80)
                                        .hiraCleanCard(colors: colors)
                                        .hiraShimmer()
                                }
                            }
                            .padding(.horizontal, 24)
                        } else {
                            // Show top 10 as preview or just a small grid
                            let previewNames = Array(viewModel.allNames.prefix(10))
                            VStack(spacing: 16) {
                                ForEach(previewNames) { item in
                                    NavigationLink(destination: AllahNameDetailView(item: item)) {
                                        AllahNameRow(item: item)
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
        .navigationTitle(appEnv.language.localizedString("home_feature_allahnames"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchQuery, prompt: appEnv.language.localizedString("allahnames_search_placeholder"))
        .overlay {
            if !viewModel.searchQuery.isEmpty {
                AllahNamesSearchResultsView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Search Results View
struct AllahNamesSearchResultsView: View {
    let viewModel: AllahNamesViewModel
    @Environment(\.appEnvironment) private var appEnv
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
                                .frame(height: 80)
                                .padding(.horizontal, 24)
                                .hiraShimmer()
                        }
                    } else if viewModel.searchResults.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchQuery)
                            .padding(.top, 40)
                    } else {
                        ForEach(viewModel.searchResults) { item in
                            NavigationLink(destination: AllahNameDetailView(item: item)) {
                                AllahNameRow(item: item)
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
        AllahNamesView()
            .environment(AppState())
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
