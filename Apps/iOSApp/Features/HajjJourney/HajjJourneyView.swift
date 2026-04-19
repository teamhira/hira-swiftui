//
//  HajjJourneyView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HajjJourneyView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = HajjJourneyViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "home_feature_hajjjourney", icon: "airplane") {
            VStack(spacing: 32) {
                // Tracking Card
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appEnv.language.localizedString("hajj_tracking_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text(appEnv.language.localizedString("hajj_tracking_desc"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.6))
                        }
                        Spacer()
                        Image(systemName: "airplane.departure")
                            .font(.title2)
                            .foregroundColor(colors.primary)
                    }
                    
                    ProgressView(value: viewModel.totalProgress)
                        .tint(colors.primary)
                        .padding(.vertical, 8)
                    
                    HStack {
                        Text(viewModel.currentStep)
                            .font(.caption.bold())
                        Spacer()
                        Text("\(Int(viewModel.totalProgress * 100))%")
                            .font(.caption.bold())
                    }
                    .foregroundColor(colors.foreground)
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(appEnv.language.localizedString("hajj_tracking_title")). \(viewModel.currentStep). \(Int(viewModel.totalProgress * 100)) percent.")
                
                // Timeline List
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("hajj_checklist_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.checklist, id: \.self) { item in
                            HStack(spacing: 16) {
                                Image(systemName: item == "Paspor & Visa" ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item == "Paspor & Visa" ? colors.primary : colors.foreground.opacity(0.2))
                                
                                Text(item)
                                    .font(.subheadline.bold())
                                    .foregroundColor(colors.foreground)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(colors.foreground.opacity(0.3))
                            }
                            .padding(16)
                            .background(colors.background)
                            .hiraCleanCard(colors: colors, radius: 16)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(item)
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}
#Preview {
    NavigationStack {
        HajjJourneyView()
            .environment(AppState())
    }
}
