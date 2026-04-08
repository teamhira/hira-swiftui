//
//  ZakatInfoModal.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Educational modal that summarizes the core concepts of Zakat based on the provided guide.
public struct ZakatInfoModal: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    let colors: ThemeModel
    
    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // Detailed Explanation Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(appEnv.language.localizedString("zakat_intro_title"))
                            .font(.title3.bold())
                            .foregroundColor(colors.primary)
                        
                        Text(appEnv.language.localizedString("zakat_intro_desc1"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.8))
                            .lineSpacing(6)
                        
                        Text(appEnv.language.localizedString("zakat_intro_desc2"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.8))
                            .lineSpacing(6)
                    }
                    
                    // Rules and Requirements Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("zakat_req_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            InfoBullet(icon: "person.fill", 
                                       title: appEnv.language.localizedString("zakat_req_islam_title"), 
                                       text: appEnv.language.localizedString("zakat_req_islam_desc"), 
                                       colors: colors)
                            InfoBullet(icon: "checkmark.seal.fill", 
                                       title: appEnv.language.localizedString("zakat_req_ownership_title"), 
                                       text: appEnv.language.localizedString("zakat_req_ownership_desc"), 
                                       colors: colors)
                            InfoBullet(icon: "cube.fill", 
                                       title: appEnv.language.localizedString("zakat_req_nisab_title"), 
                                       text: appEnv.language.localizedString("zakat_req_nisab_desc"), 
                                       colors: colors)
                            InfoBullet(icon: "calendar", 
                                       title: appEnv.language.localizedString("zakat_req_haul_title"), 
                                       text: appEnv.language.localizedString("zakat_req_haul_desc"), 
                                       colors: colors)
                        }
                    }
                    
                    // The 8 Recipients Section (Detailed)
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("zakat_recipients_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(appEnv.language.localizedString("zakat_recipients_desc"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.5))
                                .padding(.bottom, 4)
                            
                            GridAsnaf(texts: [
                                appEnv.language.localizedString("zakat_asnaf_fakir"), 
                                appEnv.language.localizedString("zakat_asnaf_miskin"), 
                                appEnv.language.localizedString("zakat_asnaf_amil"), 
                                appEnv.language.localizedString("zakat_asnaf_muallaf"), 
                                appEnv.language.localizedString("zakat_asnaf_riqab"), 
                                appEnv.language.localizedString("zakat_asnaf_gharimin"), 
                                appEnv.language.localizedString("zakat_asnaf_fisabilillah"), 
                                appEnv.language.localizedString("zakat_asnaf_ibnusabil")
                            ], colors: colors)
                        }
                    }
                    
                    // Purpose Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("zakat_purpose_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        Text(appEnv.language.localizedString("zakat_purpose_desc"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.7))
                            .lineSpacing(4)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(24)
            }
            .background(colors.background.ignoresSafeArea())
            .navigationTitle(appEnv.language.localizedString("zakat_guide_title"))
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

private struct GridAsnaf: View {
    let texts: [String]
    let colors: ThemeModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(texts, id: \.self) { text in
                HStack {
                    Circle().fill(colors.primary).frame(width: 6, height: 6)
                    Text(text)
                        .font(.caption.bold())
                        .foregroundColor(colors.foreground)
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(colors.foreground.opacity(0.04))
                .cornerRadius(10)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(text)
            }
        }
    }
}

private struct InfoBullet: View {
    let icon: String
    let title: String
    let text: String
    let colors: ThemeModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.subheadline.bold())
                .foregroundColor(colors.primary)
                .frame(width: 32)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                Text(text)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(text)")
    }
}
