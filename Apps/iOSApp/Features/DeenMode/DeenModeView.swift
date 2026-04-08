//
//  DeenModeView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DeenModeView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = DeenModeViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "home_feature_deenmode", icon: "moon.fill") {
            VStack(spacing: 32) {
                // Focus Mode Card
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appEnv.language.localizedString("deenmode_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text(appEnv.language.localizedString("deenmode_desc"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.6))
                        }
                        Spacer()
                        Image(systemName: "moon.stars.fill")
                            .font(.title2)
                            .foregroundColor(colors.primary)
                    }
                    
                    Toggle(isOn: $viewModel.isDeenModeActive) {
                        Text(appEnv.language.localizedString("deenmode_toggle"))
                            .font(.subheadline.bold())
                    }
                    .padding()
                    .background(colors.foreground.opacity(0.05))
                    .cornerRadius(12)
                    .tint(colors.primary)
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                
                // Settings List
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("deenmode_settings_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        ForEach(0..<viewModel.settings.count, id: \.self) { index in
                            HStack(spacing: 16) {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(colors.primary)
                                Text(viewModel.settings[index].title)
                                    .font(.subheadline.bold())
                                    .foregroundColor(colors.foreground)
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { viewModel.settings[index].isActive },
                                    set: { _ in viewModel.toggleSetting(at: index) }
                                ))
                                .labelsHidden()
                                .tint(colors.primary)
                                .accessibilityLabel("\(viewModel.settings[index].title) Toggle")
                            }
                            .padding(16)
                            .background(colors.background)
                            .hiraCleanCard(colors: colors, radius: 16)
                        }
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}
