//
//  TrackerView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct TrackerView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = TrackerViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "home_feature_tracker", icon: "chart.bar.fill") {
            VStack(spacing: 32) {
                // Summary Card
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appEnv.language.localizedString("tracker_summary_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text(appEnv.language.localizedString("tracker_summary_desc"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.6))
                        }
                        Spacer()
                        Image(systemName: "waveform.path.ecg")
                            .font(.title2)
                            .foregroundColor(colors.primary)
                    }
                    
                    HStack(spacing: 16) {
                        ForEach(viewModel.stats) { stat in
                            TrackerStatItem(colors: colors, title: stat.title, value: stat.value, icon: stat.icon)
                        }
                    }
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                
                // Chart Section Area
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("tracker_trend_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colors.primary.opacity(0.1))
                            .frame(height: 200)
                            .overlay {
                                Text(appEnv.language.localizedString("tracker_chart_placeholder"))
                                    .font(.caption.bold())
                                    .foregroundColor(colors.primary)
                            }
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}

private struct TrackerStatItem: View {
    @Environment(\.appEnvironment) private var appEnv
    let colors: ThemeModel
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(colors.primary)
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(colors.foreground)
            Text(title)
                .font(.caption2)
                .foregroundColor(colors.foreground.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(colors.foreground.opacity(0.04))
        .cornerRadius(16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("tracker_accessibility_stat", arguments: [title, value]))
    }
}
