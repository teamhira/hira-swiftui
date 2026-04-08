//
//  SadaqahCampaignModal.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Detailed modal for a specific Sadaqah campaign, including info and a donation button.
public struct SadaqahCampaignModal: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    let campaign: SadaqahCampaignItem
    let colors: ThemeModel
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header Illustration
                        ZStack(alignment: .topLeading) {
                            UnevenRoundedRectangle(bottomLeadingRadius: 32, bottomTrailingRadius: 32)
                                .fill(colors.primary.opacity(0.1))
                                .frame(height: 240)
                                .overlay(
                                    Image(systemName: "tent.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(colors.primary.opacity(0.3))
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 24) {
                            // Title and Progress
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(campaign.category)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(colors.primary.opacity(0.1))
                                        .foregroundColor(colors.primary)
                                        .cornerRadius(20)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(campaign.progress * 100))%")
                                        .font(.headline.bold())
                                        .foregroundColor(colors.primary)
                                }
                                
                                Text(campaign.title)
                                    .font(.title2.bold())
                                    .foregroundColor(colors.foreground)
                                
                                ProgressView(value: campaign.progress)
                                    .tint(colors.primary)
                                    .frame(height: 8)
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                    .clipShape(Capsule())
                            }
                            
                            // Description Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text(appEnv.language.localizedString("sadaqah_campaign_detail_desc_title"))
                                    .font(.headline.bold())
                                    .foregroundColor(colors.foreground)
                                
                                Text(campaign.description)
                                    .font(.body)
                                    .foregroundColor(colors.foreground.opacity(0.7))
                                    .lineSpacing(6)
                            }
                            
                            // Highlights/Stats dummy
                            HStack(spacing: 16) {
                                CampaignStatItem(icon: "person.2.fill", label: "Donors", value: "1,200+", colors: colors)
                                CampaignStatItem(icon: "calendar", label: "Days left", value: "12", colors: colors)
                                CampaignStatItem(icon: "heart.fill", label: "Urgency", value: "High", colors: colors)
                            }
                            
                            Spacer(minLength: 140) // Space for action button
                        }
                        .padding(24)
                    }
                }
                .ignoresSafeArea()
                
                // Floating Action Button
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                        Text(appEnv.language.localizedString("sadaqah_campaign_detail_btn"))
                    }
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(colors.primary)
                    .cornerRadius(24)
                    .shadow(color: colors.primary.opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(colors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.body.bold())
                            .foregroundColor(colors.foreground.opacity(0.3))
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
    }
}

private struct CampaignStatItem: View {
    let icon: String
    let label: String
    let value: String
    let colors: ThemeModel
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(colors.primary)
            
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.4))
            
            Text(value)
                .font(.caption.bold())
                .foregroundColor(colors.foreground)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(colors.foreground.opacity(0.04))
        .cornerRadius(20)
    }
}
