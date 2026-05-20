//
//  AllahNameDetailView.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI

struct AllahNameDetailView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: AsmaNameEntity
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                // Header Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(item.transliteration)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "number.circle.fill")
                            Text("#\(item.number) of 99")
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // Arabic Content
                VStack(alignment: .trailing, spacing: 20) {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(colors.primary)
                        .font(.system(size: 24))
                    
                    Text(item.arabic ?? "")
                        .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 48))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(colors.foreground)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(32)
                .background(colors.primary.opacity(0.03))
                
                // Meaning & Explanation
                VStack(alignment: .leading, spacing: 24) {
                    detailSection(title: "allahnames_meaning_label", content: item.english ?? "")
                    
                    if let meaningFull = item.meaning {
                        detailSection(title: "allahnames_description_label", content: meaningFull)
                    }
                    
                    if let explanation = item.explanation {
                        detailSection(title: "allahnames_explanation_label", content: explanation)
                    }
                    
                    if let benefits = item.benefits {
                        detailSection(title: "allahnames_benefits_label", content: benefits)
                    }
                }
                .padding(.horizontal, 24)
                
                // Actions
                HStack(spacing: 16) {
                    Button(action: shareName) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .hiraPrimaryButton(colors: colors)
                    }
                    
                    Button(action: copyName) {
                        Label("Copy", systemImage: "doc.on.doc")
                            .hiraSecondaryButton(colors: colors)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            .padding(.bottom, 40)
        }
        .background(colors.background.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func detailSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(appEnv.language.localizedString(title))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(content)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(colors.foreground.opacity(0.9))
                .lineSpacing(6)
        }
    }
    
    private func shareName() {
        let text = "\(item.transliteration) (\(item.arabic ?? ""))\n\n\(item.english ?? "")\n\n\(item.meaning ?? "")"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(av, animated: true)
        }
    }
    
    private func copyName() {
        UIPasteboard.general.string = "\(item.transliteration) (\(item.arabic ?? ""))\n\n\(item.english ?? "")\n\n\(item.meaning ?? "")"
    }
}
