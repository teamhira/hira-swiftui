//
//  JourneyHistoryView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct JourneyHistoryView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    let state: JourneyState
    let colors: ThemeModel
    
    @State private var selectedTab: String = "daily"
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Tabs
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            TabButton(title: appEnv.language.localizedString("hijrah_history_tab_daily"), id: "daily", selection: $selectedTab, animation: animation, colors: colors)
                            TabButton(title: appEnv.language.localizedString("hijrah_history_tab_weekly"), id: "weekly", selection: $selectedTab, animation: animation, colors: colors)
                            TabButton(title: appEnv.language.localizedString("hijrah_history_tab_monthly"), id: "monthly", selection: $selectedTab, animation: animation, colors: colors)
                            TabButton(title: appEnv.language.localizedString("hijrah_history_tab_yearly"), id: "yearly", selection: $selectedTab, animation: animation, colors: colors)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.vertical, 12)
                    
                    Divider().opacity(0.1)
                }
                .background(colors.background)
                
                ZStack {
                    colors.background.ignoresSafeArea()
                    
                    if selectedTab == "daily" {
                        dailyContentView
                    } else {
                        emptyStateView
                    }
                }
            }
            .navigationTitle(appEnv.language.localizedString("hijrah_dash_history"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(colors.foreground.opacity(0.5))
                    }
                }
            }
        }
    }
    
    private var dailyContentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if state.completedMissionIds.isEmpty {
                    emptyStateView.padding(.top, 100)
                } else {
                    let sortedIds = Array(state.completedMissionIds).sorted()
                    ForEach(sortedIds, id: \.self) { missionId in
                        HistoryCard(
                            missionName: appEnv.language.localizedString(missionId),
                            date: state.completionDates[missionId] ?? Date(),
                            colors: colors
                        )
                    }
                }
            }
            .padding(24)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.05))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 48))
                    .foregroundColor(colors.primary.opacity(0.3))
            }
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("hijrah_no_history"))
                    .font(.headline)
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("hijrah_no_history_desc"))
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}

// MARK: - Components
private struct HistoryCard: View {
    let missionName: String
    let date: Date
    let colors: ThemeModel
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(missionName)
                    .font(.body.bold())
                    .foregroundColor(colors.foreground)
                
                Text(date.formatted(date: .long, time: .shortened))
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2.bold())
                .foregroundColor(colors.foreground.opacity(0.2))
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 20)
    }
}

private struct TabButton: View {
    let title: String
    let id: String
    @Binding var selection: String
    var animation: Namespace.ID
    let colors: ThemeModel
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selection = id
            }
        }) {
            VStack(spacing: 12) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(selection == id ? colors.primary : colors.foreground.opacity(0.4))
                
                ZStack {
                    if selection == id {
                        Capsule()
                            .fill(colors.primary)
                            .frame(width: 24, height: 4)
                            .matchedGeometryEffect(id: "tab_pill", in: animation)
                    } else {
                        Capsule()
                            .fill(Color.clear)
                            .frame(width: 24, height: 4)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
