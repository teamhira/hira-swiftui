//
//  DeenModeView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DeenModeView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = DeenModeViewModel.shared
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            if viewModel.isDeenModeActive {
                DeenActiveSessionView(
                    focusType: viewModel.selectedFocusType,
                    duration: viewModel.formatDuration(viewModel.sessionDuration),
                    colors: colors
                ) {
                    withAnimation(.spring()) {
                        viewModel.toggleDeenMode()
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                mainViewContent()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_deenmode"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func mainViewContent() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.lg) {
                // Header Card
                headerCard()
                
                // Focus Type Selector
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text(appEnv.language.localizedString("deenmode_settings_title"))
                        .font(TextStyle.headline)
                        .foregroundColor(colors.foreground)
                        .padding(.horizontal, 4)
                    
                    DeenFocusTypeSelector(selectedType: $viewModel.selectedFocusType, colors: colors)
                }
                
                // Settings List
                VStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.settings.indices, id: \.self) { index in
                        DeenSettingRow(setting: viewModel.settings[index], colors: colors) {
                            viewModel.toggleSetting(at: index)
                        }
                    }
                }
                
                // History / Stats
                if !viewModel.history.isEmpty {
                    historySection()
                }
                
                // Start Button
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.toggleDeenMode()
                    }
                }) {
                    Text(appEnv.language.localizedString("deenmode_toggle"))
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colors.primary)
                        .cornerRadius(20)
                        .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.top, AppSpacing.lg)
            }
            .padding(AppSpacing.md)
        }
    }
    
    @ViewBuilder
    private func headerCard() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(appEnv.language.localizedString("deenmode_title"))
                    .font(.title2.bold())
                    .foregroundColor(colors.foreground)
                Text(appEnv.language.localizedString("deenmode_desc"))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 44))
                .foregroundColor(colors.primary)
        }
        .padding(24)
        .background(colors.card)
        .cornerRadius(24)
        .shadow(color: AppShadow.sm.color, radius: AppShadow.sm.radius, x: AppShadow.sm.x, y: AppShadow.sm.y)
    }
    
    @ViewBuilder
    private func historySection() -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(appEnv.language.localizedString("deenmode_session_history"))
                .font(TextStyle.headline)
                .foregroundColor(colors.foreground)
                .padding(.horizontal, 4)
            
            VStack(spacing: AppSpacing.sm) {
                // Total Summary
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(colors.primary)
                    Text(appEnv.language.localizedString("deenmode_total_focus"))
                        .font(TextStyle.caption.bold())
                        .foregroundColor(colors.foreground)
                    Spacer()
                    Text(viewModel.formatDuration(viewModel.totalFocusTimeSeconds))
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(colors.primary)
                }
                .padding()
                .background(colors.card)
                .cornerRadius(16)
                
                // Recent sessions (last 3)
                ForEach(viewModel.history.suffix(3).reversed()) { session in
                    HStack {
                        Image(systemName: session.type.icon)
                            .foregroundColor(colors.foreground.opacity(0.4))
                        Text(appEnv.language.localizedString(session.type.titleKey))
                            .font(TextStyle.caption)
                            .foregroundColor(colors.foreground)
                        Spacer()
                        Text(viewModel.formatDuration(session.durationSeconds))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(colors.foreground.opacity(0.6))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            .padding(.vertical, 8)
            .background(colors.card)
            .cornerRadius(20)
            .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
        }
    }
}

#Preview {
    NavigationStack {
        DeenModeView()
            .environment(AppState())
    }
}
