//
//  HadithListView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HadithListView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    let category: String
    @State private var viewModel = HadithViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appEnv.language.localizedString(category))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "books.vertical.fill")
                                .foregroundColor(colors.primary)
                            Text("\(viewModel.hadiths.count) \(Text(appEnv.language.localizedString("hadith_explore_btn")).font(.system(size: 10)))")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Hadith List Section
                    if viewModel.isLoading && viewModel.hadiths.isEmpty {
                        VStack(spacing: 16) {
                            ForEach(0..<5, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(colors.background)
                                    .frame(height: 120)
                                    .hiraCleanCard(colors: colors)
                                    .hiraShimmer()
                            }
                        }
                        .padding(.horizontal, 24)
                    } else if viewModel.hadiths.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 50))
                                .foregroundColor(colors.primary.opacity(0.3))
                            
                            Text(appEnv.language.localizedString("hadith_not_found"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.hadiths) { item in
                                Button(action: {
                                    router.navigate(to: .hadithDetail(item))
                                }) {
                                    HadithRow(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentItem: item)
                                }
                            }
                            
                            if viewModel.isLoading && !viewModel.hadiths.isEmpty {
                                ProgressView()
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .task {
            viewModel.fetchHadiths(for: category)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchQuery, prompt: appEnv.language.localizedString("dua_search_placeholder"))
        .overlay {
            if !viewModel.searchQuery.isEmpty {
                HadithSearchResultsView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HadithListView(category: "hadith_col_arbain")
    }
}
