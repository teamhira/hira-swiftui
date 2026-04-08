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
                            Text("\(viewModel.filteredHadiths(for: category).count) \(Text(appEnv.language.localizedString("hadith_explore_btn")).font(.system(size: 10)))")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Hadith List Section
                    let filtered = viewModel.filteredHadiths(for: category)
                    
                    if filtered.isEmpty {
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
                        VStack(spacing: 16) {
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
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HadithListView(category: "hadith_col_arbain")
    }
}
