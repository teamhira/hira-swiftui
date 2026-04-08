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
    
    var body: some View {
        FeatureView(titleKey: "home_feature_khatam", icon: "book.fill") {
            VStack(spacing: 32) {
                // Progress Card
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appEnv.language.localizedString("khatam_progress_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text(appEnv.language.localizedString("khatam_progress_desc"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.6))
                        }
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(colors.primary)
                    }
                    
                    ProgressView(value: viewModel.progress)
                        .tint(colors.primary)
                        .scaleEffect(x: 1, y: 3, anchor: .center)
                    
                    HStack {
                        Text("\(viewModel.currentHalaman) / \(viewModel.totalHalaman) Halaman")
                            .font(.caption.bold())
                        Spacer()
                        Text("\(viewModel.progressPercentage)%")
                            .font(.caption.bold())
                    }
                    .foregroundColor(colors.foreground)
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(appEnv.language.localizedString("khatam_accessibility_progress", arguments: [viewModel.currentHalaman, viewModel.totalHalaman, viewModel.progressPercentage]))
                
                // History List
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("khatam_history_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.history) { record in
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(colors.primary.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay {
                                        Image(systemName: "book.fill")
                                            .font(.caption)
                                            .foregroundColor(colors.primary)
                                    }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(record.surahName)
                                        .font(.subheadline.bold())
                                        .foregroundColor(colors.foreground)
                                    Text(record.range)
                                        .font(.caption)
                                        .foregroundColor(colors.foreground.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Text(record.date)
                                    .font(.caption)
                                    .foregroundColor(colors.foreground.opacity(0.4))
                            }
                            .padding(16)
                            .background(colors.background)
                            .hiraCleanCard(colors: colors, radius: 16)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(record.surahName). \(record.range). \(record.date)")
                        }
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}
