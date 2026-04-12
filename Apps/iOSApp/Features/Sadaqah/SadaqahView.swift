//
//  SadaqahView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Main dashboard for the Sadaqah feature, listing categories and programs.
public struct SadaqahView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = SadaqahViewModel()
    @State private var isShowingInfo: Bool = false
    @State private var selectedCampaign: SadaqahCampaignItem?
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Headline Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text(appEnv.language.localizedString("sadaqah_dashboard_title"))
                            .font(.title2.bold())
                            .foregroundColor(colors.foreground)
                        
                        Text(appEnv.language.localizedString("sadaqah_dashboard_desc"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.6))
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    // Sadaqah Categories Grid
                    VStack(spacing: 12) {
                        ForEach(SadaqahType.allCases) { type in
                            NavigationLink(destination: destination(for: type)) {
                                SadaqahTypeCard(type: type, colors: colors)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel(appEnv.language.localizedString(type.localizedTitleKey))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Campaign/Program highlight
                    VStack(alignment: .leading, spacing: 16) {
                        Text(appEnv.language.localizedString("sadaqah_campaign_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        ForEach(viewModel.campaigns) { campaign in
                            Button(action: { selectedCampaign = campaign }) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(campaign.title)
                                                .font(.subheadline.bold())
                                                .foregroundColor(colors.foreground)
                                            Text(campaign.category)
                                                .font(.caption2.bold())
                                                .foregroundColor(colors.primary)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 2)
                                                .background(colors.primary.opacity(0.1))
                                                .cornerRadius(4)
                                        }
                                        Spacer()
                                        Text("\(Int(campaign.progress * 100))%")
                                            .font(.caption.bold())
                                            .foregroundColor(colors.primary)
                                    }
                                    
                                    ProgressView(value: campaign.progress)
                                        .tint(colors.primary)
                                        .frame(height: 4)
                                }
                                .padding(16)
                                .background(colors.background)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .hiraCleanCard(colors: colors, radius: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel("Campaign: \(campaign.title)")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(appEnv.language.localizedString("home_feature_sadaqah"))
                    .font(.headline.bold())
                    .foregroundColor(colors.foreground)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isShowingInfo = true }) {
                    Image(systemName: "info.circle")
                        .font(.body.bold())
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel("Information")
            }
        }
        .sheet(isPresented: $isShowingInfo) {
            SadaqahInfoModal(colors: colors)
        }
        .sheet(item: $selectedCampaign) { campaign in
            SadaqahCampaignModal(campaign: campaign, colors: colors)
        }
    }
    
    @ViewBuilder
    private func destination(for type: SadaqahType) -> some View {
        switch type {
        case .subuh: 
            SadaqahSubuhView()
        case .cash: 
            SadaqahDonationView()
        case .physical: 
            SadaqahGoodsView()
        case .waqf: 
            SadaqahDonationView()
        }
    }
}
#Preview {
    NavigationStack {
        SadaqahView()
            .environment(AppState())
    }
}
