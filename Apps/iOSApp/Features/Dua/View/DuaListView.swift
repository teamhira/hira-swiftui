//
//  DuaListView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DuaListView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    let category: String
    @State private var viewModel = DuaViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "number.square.fill")
                                .foregroundColor(colors.primary)
                            Text("\(viewModel.duas.count) \(Text("duas_found"))")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Dua List Section
                    if viewModel.isLoading {
                        VStack(spacing: 16) {
                            ForEach(0..<5, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(colors.foreground.opacity(0.05))
                                    .frame(height: 100)
                                    .hiraShimmer()
                            }
                        }
                        .padding(.horizontal, 24)
                    } else if viewModel.duas.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(colors.primary.opacity(0.3))
                            
                            Text(LocalizedStringKey("dua_not_found_title"))
                                .font(.headline.bold())
                            Text(LocalizedStringKey("dua_not_found_desc"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewModel.duas) { item in
                                NavigationLink(value: AppRoute.duaDetail(item)) {
                                    DuaRow(item: item)
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
        .onAppear {
            viewModel.fetchDuasByCategory(category)
        }
    }
}


#Preview {
    NavigationStack {
        DuaListView(category: "dua_category_all")
    }
}
