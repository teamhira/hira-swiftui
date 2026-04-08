//
//  SadaqahInfoModal.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Educational modal that summarizes the core concepts of Sadaqah.
public struct SadaqahInfoModal: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    let colors: ThemeModel
    
    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // Introduction
                    VStack(alignment: .leading, spacing: 16) {
                        Text(appEnv.language.localizedString("sadaqah_info_guide_desc"))
                            .font(.title3.bold())
                            .foregroundColor(colors.primary)
                        
                        Text(appEnv.language.localizedString("sadaqah_info_intro_text"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.8))
                            .lineSpacing(6)
                    }
                    
                    // Benefits Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("sadaqah_info_benefit_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SadaqahBenefitItem(icon: "shield.righthalf.filled", 
                                             text: appEnv.language.localizedString("sadaqah_info_benefit_1"), 
                                             colors: colors)
                            SadaqahBenefitItem(icon: "chart.line.uptrend.xyaxis", 
                                             text: appEnv.language.localizedString("sadaqah_info_benefit_2"), 
                                             colors: colors)
                            SadaqahBenefitItem(icon: "sparkles", 
                                             text: appEnv.language.localizedString("sadaqah_info_benefit_3"), 
                                             colors: colors)
                        }
                    }
                    
                    // Types of Sadaqah
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appEnv.language.localizedString("sadaqah_info_types_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SadaqahTypeItem(title: appEnv.language.localizedString("sadaqah_info_type_jariyah_title"),
                                          desc: appEnv.language.localizedString("sadaqah_info_type_jariyah_desc"),
                                          colors: colors)
                            SadaqahTypeItem(title: appEnv.language.localizedString("sadaqah_info_type_hidden_title"),
                                          desc: appEnv.language.localizedString("sadaqah_info_type_hidden_desc"),
                                          colors: colors)
                        }
                    }
                    
                    // Difference with Zakat
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appEnv.language.localizedString("sadaqah_info_diff_zakat_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        Text(appEnv.language.localizedString("sadaqah_info_diff_zakat_desc"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.7))
                            .lineSpacing(4)
                            .padding(20)
                            .background(colors.primary.opacity(0.05))
                            .cornerRadius(20)
                    }
                    
                    // Ethics of Sadaqah
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Adab & Etika Bersedekah")
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        
                        Text("Niat tulus ikhlas karena Allah, mendahulukan kerabat terdekat, dan menghindari sikap riya' atau menyakiti perasaan penerima.")
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.7))
                            .lineSpacing(6)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(colors.foreground.opacity(0.04))
                    .cornerRadius(20)
                    
                    Spacer(minLength: 40)
                }
                .padding(24)
            }
            .background(colors.background.ignoresSafeArea())
            .navigationTitle(appEnv.language.localizedString("sadaqah_info_modal_title"))
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

private struct SadaqahBenefitItem: View {
    let icon: String
    let text: String
    let colors: ThemeModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(colors.primary)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(colors.foreground.opacity(0.8))
        }
    }
}

private struct SadaqahTypeItem: View {
    let title: String
    let desc: String
    let colors: ThemeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(colors.foreground)
            Text(desc)
                .font(.caption)
                .foregroundColor(colors.foreground.opacity(0.6))
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.foreground.opacity(0.04))
        .cornerRadius(20)
    }
}
