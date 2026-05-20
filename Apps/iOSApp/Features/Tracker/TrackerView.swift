//
//  TrackerView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct TrackerView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = TrackerViewModel.shared
    private var colors: ThemeModel { appEnv.theme.current }
    
    @State private var selectedEntry: TrackerEntry?
    @State private var showConfirmAlert = false
    @State private var showUncheckAlert = false
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    // MARK: - Summary Progress Card
                    summaryCard()
                    
                    // MARK: - Today's Items
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        HStack {
                            Text(appEnv.language.localizedString("tracker_today_progress"))
                                .font(TextStyle.headline)
                                .foregroundColor(colors.foreground)
                            
                            Spacer()
                            
                            NavigationLink {
                                TrackerHistoryView(history: viewModel.history, colors: colors)
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.arrow.circlepath")
                                    Text(appEnv.language.localizedString("tracker_history_title"))
                                }
                                .font(.caption.bold())
                                .foregroundColor(colors.primary)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        LazyVStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.todayEntries) { entry in
                                TrackerItemRow(entry: entry, colors: colors) {
                                    self.selectedEntry = entry
                                    if entry.isCompleted {
                                        self.showUncheckAlert = true
                                    } else {
                                        self.showConfirmAlert = true
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_tracker"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(appEnv.language.localizedString("tracker_confirm_title"), isPresented: $showConfirmAlert) {
            Button(appEnv.language.localizedString("common_cancel"), role: .cancel) { }
            Button(appEnv.language.localizedString("common_ok")) {
                if let entry = selectedEntry {
                    withAnimation {
                        viewModel.toggleEntry(entry)
                    }
                }
            }
        } message: {
            Text(appEnv.language.localizedString("tracker_confirm_message"))
        }
        .alert(appEnv.language.localizedString("tracker_uncheck_confirm_title"), isPresented: $showUncheckAlert) {
            Button(appEnv.language.localizedString("common_cancel"), role: .cancel) { }
            Button(appEnv.language.localizedString("common_ok"), role: .destructive) {
                if let entry = selectedEntry {
                    withAnimation {
                        viewModel.toggleEntry(entry)
                    }
                }
            }
        } message: {
            Text(appEnv.language.localizedString("tracker_uncheck_confirm_message"))
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    @ViewBuilder
    private func summaryCard() -> some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appEnv.language.localizedString("tracker_summary_title"))
                        .font(.title3.bold())
                        .foregroundColor(colors.foreground)
                    Text(appEnv.language.localizedString("tracker_summary_desc"))
                        .font(.caption)
                        .foregroundColor(colors.foreground.opacity(0.6))
                }
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(colors.primary.opacity(0.1), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: Double(viewModel.completionPercentage) / 100.0)
                        .stroke(colors.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(viewModel.completionPercentage)%")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(colors.primary)
                }
            }
            
            HStack(spacing: AppSpacing.md) {
                summaryStatItem(title: "Completed", value: "\(viewModel.todayEntries.filter { $0.isCompleted }.count)", icon: "checkmark.circle.fill")
                summaryStatItem(title: "Target", value: "\(viewModel.todayEntries.count)", icon: "target")
            }
        }
        .padding(24)
        .background(colors.card)
        .cornerRadius(24)
        .shadow(color: AppShadow.sm.color, radius: AppShadow.sm.radius, x: AppShadow.sm.x, y: AppShadow.sm.y)
    }
    
    @ViewBuilder
    private func summaryStatItem(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(colors.primary)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline.bold())
                    .foregroundColor(colors.foreground)
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.foreground.opacity(0.4))
                    .textCase(.uppercase)
            }
            Spacer()
        }
        .padding()
        .background(colors.background)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        TrackerView()
            .environment(AppState())
    }
}
