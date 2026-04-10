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
    @Environment(AppRouter.self) private var router
    
    @State private var store = HomeFeatureStoreModel()
    @State private var showMoreSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(appEnv.language.localizedString("home_features_section"))
                    .font(.headline.bold())
                    .foregroundColor(colors.foreground)
                
                Spacer()
                
                Button(action: { showMoreSheet = true }) {
                    Text(appEnv.language.localizedString("home_features_edit"))
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                }
            }
            .padding(.horizontal, 24)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                // Show visible features from store
                ForEach(store.visibleFeatures) { item in
                    FeatureButton(item: item, colors: colors, appEnv: appEnv) {
                        handleNavigation(for: item.type)
                    }
                }
                
                // Always show "More" button at the end
                Button(action: { showMoreSheet = true }) {
                    VStack(spacing: AppSpacing.sm + 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(colors.background)
                                .hiraCleanCard(colors: colors, radius: 20)
                            
                            Image(systemName: "ellipsis")
                                .font(.title2)
                                .foregroundColor(colors.primary)
                        }
                        .frame(height: 70)
                        
                        Text(appEnv.language.localizedString("home_feature_more"))
                            .font(.caption.bold())
                            .foregroundColor(colors.foreground)
                            .lineLimit(1)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(appEnv.language.localizedString("home_feature_more"))
                .accessibilityHint(appEnv.language.localizedString("home_accessibility_more_hint"))
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showMoreSheet) {
            MoreFeaturesSheet(colors: colors, store: store)
        }
    }
    
    private func handleNavigation(for type: HomeFeatureType) {
        switch type {
        case .tasbih: router.navigate(to: .tasbih())
        case .qibla: router.navigate(to: .qibla)
        case .zakat: router.navigate(to: .zakat)
        case .sadaqah: router.navigate(to: .sadaqah)
        case .achievements: router.navigate(to: .achievements)
        case .askAI: router.navigate(to: .chatbot)
        case .dua: router.navigate(to: .dua)
        case .hadith: router.navigate(to: .hadith)
        case .mosques: router.navigate(to: .mosques)
        case .khatam: router.navigate(to: .khatam)
        case .deenMode: router.navigate(to: .deenMode)
        case .journal: router.navigate(to: .journal)
        case .tracker: router.navigate(to: .tracker)
        case .calendar: router.navigate(to: .calendar)
        case .halal: router.navigate(to: .halal)
        case .hajjJourney: router.navigate(to: .hajjJourney)
        case .hajjUmrah: router.navigate(to: .hajjUmrah)
        case .prayerTimes: router.navigate(to: .prayerTimes)
        case .tarteel: router.navigate(to: .tarteel)
        }
    }
}

private struct FeatureButton: View {
    let item: HomeFeatureModel
    let colors: ThemeModel
    let appEnv: AppEnvironment
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm + 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colors.background)
                        .hiraCleanCard(colors: colors, radius: 20)
                    
                    Image(systemName: item.type.icon)
                        .font(.title2)
                        .foregroundColor(colors.primary)
                }
                .frame(height: 70)
                
                Text(appEnv.language.localizedString(item.type.titleKey))
                    .font(.caption.bold())
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(appEnv.language.localizedString(item.type.titleKey))
        .accessibilityHint(appEnv.language.localizedString("home_accessibility_feature_nav_hint", arguments: [appEnv.language.localizedString(item.type.titleKey)]))
    }
}
