//
//  DuaDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct DuaDetailView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: DuaEntity
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(item.category.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(colors.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(colors.primary.opacity(0.1))
                            .clipShape(Capsule())
                        
                        Text(item.title)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    // Main Content
                    VStack(spacing: 40) {
                        // Arabic Section
                        if !item.arabic.isEmpty {
                            VStack(alignment: .trailing, spacing: 20) {
                                Text(item.arabic)
                                    .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 34))
                                    .lineSpacing(14)
                                    .multilineTextAlignment(.trailing)
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .foregroundColor(colors.foreground)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                if !item.transliteration.isEmpty {
                                    Text(item.transliteration)
                                        .font(.system(size: 18, weight: .medium, design: .serif))
                                        .italic()
                                        .foregroundColor(colors.primary.opacity(0.8))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        
                        // Translation Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Rectangle()
                                    .fill(colors.primary)
                                    .frame(width: 4, height: 20)
                                    .cornerRadius(2)
                                
                                Text(LocalizedStringKey("dua_item_translation_label"))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(item.translation)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                .foregroundColor(colors.foreground.opacity(0.9))
                                .lineSpacing(8)
                                .multilineTextAlignment(.leading)
                        }
                        
                        // Reference Section
                        if let source = item.source, !source.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(colors.primary.opacity(0.4))
                                Text(source)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .italic()
                            }
                            .padding(.top, 8)
                        }
                        
                        // Share Actions
                        HStack(spacing: 16) {
                            Button(action: shareDua) {
                                Label("Share", systemImage: "square.and.arrow.up")
                                    .hiraPrimaryButton(colors: colors)
                            }
                            
                            Button(action: copyDua) {
                                Label("Copy", systemImage: "doc.on.doc")
                                    .hiraSecondaryButton(colors: colors)
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Actions
    private func shareDua() {
        let text = "\(item.title)\n\n\(item.arabic)\n\n\(item.translation)"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(av, animated: true)
        }
    }
    
    private func copyDua() {
        UIPasteboard.general.string = "\(item.arabic)\n\n\(item.translation)"
    }
}

#Preview {
    NavigationStack {
        DuaDetailView(item: DuaEntity(
            id: 1,
            category: "morning",
            title: "Morning Remembrance",
            arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ",
            transliteration: "Asbahna wa asbahal-mulku lillah",
            translation: "We have reached the morning...",
            source: "Abu Dawud",
            repeatOnce: 1
        ))
    }
}

