//
//  HomeFeatureGrid.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct HomeFeatureGrid: View {
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    // Feature configuration with localization keys
    private struct FeatureItem {
        let titleKey: String
        let icon: String
    }
    
    private let features = [
        FeatureItem(titleKey: "home_feature_zakat", icon: "banknote.fill"),
        FeatureItem(titleKey: "home_feature_qibla", icon: "safari.fill"),
        FeatureItem(titleKey: "home_feature_tasbih", icon: "circle.grid.3x3.circle.fill"),
        FeatureItem(titleKey: "home_feature_doa", icon: "hands.sparkles.fill"),
        FeatureItem(titleKey: "home_feature_hadith", icon: "book.closed.fill"),
        FeatureItem(titleKey: "home_feature_more", icon: "ellipsis.circle.fill")
    ]
    
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(appEnv.language.localizedString("home_features_section"))
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
                .padding(.horizontal, 24)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(features, id: \.titleKey) { item in
                    let localizedTitle = appEnv.language.localizedString(item.titleKey)
                    
                    Button(action: {
                        if item.titleKey == "home_feature_tasbih" {
                            router.navigate(to: .tasbih)
                        } else if item.titleKey == "home_feature_qibla" {
                            router.navigate(to: .qibla)
                        } else if item.titleKey == "home_feature_zakat" {
                            router.navigate(to: .charity)
                        } else if item.titleKey == "home_feature_doa" {
                            router.navigate(to: .search)
                        } else if item.titleKey == "home_feature_more" {
                            router.navigate(to: .search)
                        }
                    }) {
                        VStack(spacing: AppSpacing.sm + 4) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(colors.background)
                                    .hiraCleanCard(colors: colors, radius: 20)
                                
                                Image(systemName: item.icon)
                                    .font(.title2)
                                    .foregroundColor(colors.primary)
                            }
                            .frame(height: 70)
                            
                            Text(localizedTitle)
                                .font(.caption.bold())
                                .foregroundColor(colors.foreground)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(appEnv.language.localizedString("home_features_section"))
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
