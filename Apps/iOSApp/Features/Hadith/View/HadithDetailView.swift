//
//  HadithDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct HadithDetailView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    let item: HadithEntity
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                // Header Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(item.collectionName)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "number.circle.fill")
                            Text("#\(item.hadithnumber)")
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                        
                        Spacer()
                        
                        if let grade = item.grade {
                            Text(grade)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(colors.primary.opacity(0.1))
                                .foregroundColor(colors.primary)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // Arabic Content
                if !item.arabic.isEmpty {
                    VStack(alignment: .trailing, spacing: 20) {
                        Image(systemName: "book.fill")
                            .foregroundColor(colors.primary)
                            .font(.system(size: 24))
                        
                        Text(item.arabic)
                            .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 30))
                            .lineSpacing(14)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(colors.foreground)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(32)
                    .background(colors.primary.opacity(0.03))
                }
                
                // Translation Content
                VStack(alignment: .leading, spacing: 12) {
                    Text(appEnv.language.localizedString("dua_item_translation_label"))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(item.english)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(colors.foreground.opacity(0.9))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                
                // Actions
                HStack(spacing: 16) {
                    Button(action: shareHadith) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .hiraPrimaryButton(colors: colors)
                    }
                    
                    Button(action: copyHadith) {
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
    
    // MARK: - Actions
    private func shareHadith() { 
        let text = "\(item.collectionName) #\(item.hadithnumber)\n\n\(item.arabic)\n\n\(item.english)"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(av, animated: true)
        }
    }
    
    private func copyHadith() { 
        UIPasteboard.general.string = "\(item.collectionName) #\(item.hadithnumber)\n\n\(item.arabic)\n\n\(item.english)"
    }
}

#Preview {
    NavigationStack {
        HadithDetailView(item: HadithEntity(
            id: "bukhari-1",
            collection: "bukhari",
            collectionName: "Sahih al-Bukhari",
            hadithnumber: "1",
            arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
            english: "Actions are but by intentions...",
            grade: "Sahih"
        ))
    }
}
