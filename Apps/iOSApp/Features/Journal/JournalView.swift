//
//  JournalView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = JournalViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    @State private var showAddSheet = false
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    // MARK: - New Entry CTA Card
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(appEnv.language.localizedString("journal_new_entry_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text(appEnv.language.localizedString("journal_new_entry_desc"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.6))
                            
                            Button(action: { showAddSheet = true }) {
                                Text(appEnv.language.localizedString("journal_add_btn"))
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(colors.primary)
                                    .cornerRadius(20)
                                    .shadow(color: colors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(colors.primary.opacity(0.05))
                                .frame(width: 80, height: 80)
                            Image(systemName: "pencil.and.outline")
                                .font(.system(size: 32))
                                .foregroundColor(colors.primary)
                        }
                    }
                    .padding(24)
                    .background(colors.card)
                    .cornerRadius(24)
                    .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
                    
                    // MARK: - Timeline History
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        HStack {
                            Text(appEnv.language.localizedString("journal_timeline_title"))
                                .font(TextStyle.headline)
                                .foregroundColor(colors.foreground)
                            
                            Spacer()
                            
                            Text("\(viewModel.entries.count)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(colors.primary)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 4)
                        
                        if viewModel.entries.isEmpty {
                            emptyJournalView()
                        } else {
                            LazyVStack(spacing: AppSpacing.md) {
                                ForEach(viewModel.entries) { entry in
                                    NavigationLink {
                                        JournalDetailView(entry: entry, viewModel: $viewModel)
                                    } label: {
                                        JournalEntryRow(entry: entry, colors: colors)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_journal"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddSheet) {
            AddJournalView(viewModel: $viewModel)
        }
    }
    
    @ViewBuilder
    private func emptyJournalView() -> some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(colors.primary.opacity(0.2))
            
            VStack(spacing: 4) {
                Text(appEnv.language.localizedString("journal_empty_title"))
                    .font(TextStyle.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("journal_empty_desc"))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(colors.card)
        .cornerRadius(20)
    }
}

#Preview {
    NavigationStack {
        JournalView()
            .environment(AppState())
    }
}
