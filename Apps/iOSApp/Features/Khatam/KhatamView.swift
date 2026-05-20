//
//  KhatamView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct KhatamView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = KhatamViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    @State private var showSetup: Bool = false
    @State private var showManualEntry: Bool = false
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView {
                    // MARK: - Progress Tab
                    progressTabView()
                        .tabItem {
                            Label(appEnv.language.localizedString("khatam_tab_progress"), systemImage: "figure.walk")
                        }
                    
                    // MARK: - History Tab
                    historyTabView()
                        .tabItem {
                            Label(appEnv.language.localizedString("khatam_tab_history"), systemImage: "clock.arrow.circlepath")
                        }
                }
                .tint(colors.primary)
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_khatam"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.activeGoal != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: { viewModel.deleteCurrentGoal() }) {
                            Label(appEnv.language.localizedString("khatam_cancel_goal"), systemImage: "trash")
                        }
                        Button(action: { showSetup = true }) {
                            Label(appEnv.language.localizedString("khatam_new_goal_title"), systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(colors.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showSetup) {
            KhatamSetupView(viewModel: viewModel, colors: colors)
        }
        .sheet(isPresented: $showManualEntry) {
            KhatamManualEntryView(viewModel: viewModel, colors: colors)
        }
    }
    
    // MARK: - Tab Views
    
    @ViewBuilder
    private func progressTabView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xl) {
                if let goal = viewModel.activeGoal {
                    VStack(spacing: AppSpacing.lg) {
                        NavigationLink {
                            KhatamDetailView(title: goal.title, logs: goal.logs, colors: colors)
                        } label: {
                            KhatamProgressCard(goal: goal, colors: colors)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        KhatamTimelineView(goal: goal, viewModel: viewModel, colors: colors)
                        
                        Button(action: { showManualEntry = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text(appEnv.language.localizedString("khatam_add_progress"))
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                    }

                } else {
                    emptyStateView()
                }
            }
            .padding(AppSpacing.md)
        }
    }
    
    @ViewBuilder
    private func historyTabView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                if viewModel.history.isEmpty {
                    VStack(spacing: AppSpacing.md) {
                        Spacer(minLength: 100)
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(colors.primary.opacity(0.2))
                        Text(appEnv.language.localizedString("hijrah_no_history"))
                            .font(TextStyle.headline)
                            .foregroundColor(colors.foreground.opacity(0.6))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(appEnv.language.localizedString("khatam_history_title"))
                            .font(TextStyle.title3)
                            .foregroundColor(colors.foreground)
                        
                        Text(appEnv.language.localizedString("khatam_history_stats", arguments: [viewModel.history.count]))
                            .font(TextStyle.caption)
                            .foregroundColor(colors.foreground.opacity(0.6))
                    }
                    .padding(.horizontal, AppSpacing.xs)
                    
                    VStack(spacing: AppSpacing.md) {
                        ForEach(viewModel.history) { record in
                            NavigationLink {
                                KhatamDetailView(title: record.title, logs: record.logs, colors: colors)
                            } label: {
                                KhatamHistoryRow(record: record, colors: colors)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(AppSpacing.md)
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack(spacing: AppSpacing.md) {
            sectionCard(title: "", icon: "book.closed.fill") {
                VStack(spacing: AppSpacing.md) {
                    Text(appEnv.language.localizedString("khatam_no_active_goal"))
                        .font(TextStyle.headline)
                        .foregroundColor(colors.foreground)
                    
                    Text(appEnv.language.localizedString("khatam_no_active_goal_desc"))
                        .font(TextStyle.caption)
                        .foregroundColor(colors.foreground.opacity(0.6))
                        .multilineTextAlignment(.center)
                    
                    Button(action: { showSetup = true }) {
                        Text(appEnv.language.localizedString("khatam_new_goal_title"))
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical, AppSpacing.lg)
            }
        }
        .padding(.top, 20)
    }

    
    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            if !title.isEmpty {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(colors.primary)
                    Text(title)
                        .font(TextStyle.headline)
                        .foregroundColor(colors.foreground)
                }
            }
            
            content()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }


}
