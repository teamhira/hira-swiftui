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
    let item: HadithItem
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Main Content Card
                    VStack(spacing: 32) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey(item.title))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            
                            Divider()
                            
                            HStack {
                                Text(appEnv.language.localizedString("hadith_narrated_by", arguments: [item.narrator]))
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(colors.primary)
                                
                                Spacer()
                                
                                Text(item.source)
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Arabic Section (Optional)
                        if let arabic = item.arabic {
                            VStack(alignment: .trailing, spacing: 16) {
                                HStack {
                                    Image(systemName: "character.book.closed.fill")
                                        .foregroundColor(colors.primary)
                                    Text(appEnv.language.localizedString("dua_item_arabic_label")) // Recycled key
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                Text(arabic)
                                    .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 30))
                                    .lineSpacing(12)
                                    .multilineTextAlignment(.trailing)
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(colors.foreground)
                            }
                            .padding(20)
                            .background(colors.primary.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        
                        // Body Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text(appEnv.language.localizedString("dua_item_translation_label")) // Recycled key
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            Text(LocalizedStringKey(item.body))
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(colors.foreground.opacity(0.9))
                                .lineSpacing(6)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Share Actions
                        HStack(spacing: 16) {
                            Button(action: shareHadith) {
                                Label("Share", systemImage: "square.and.arrow.up")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(colors.primary)
                                    .clipShape(Capsule())
                            }
                            
                            Button(action: copyHadith) {
                                Label("Copy", systemImage: "doc.on.doc")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(colors.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(colors.primary.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(24)
                    .background(colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .hiraCleanCard(colors: colors)
                    .padding(20)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Actions
    private func shareHadith() { }
    private func copyHadith() { 
        UIPasteboard.general.string = "\(item.arabic ?? "")\n\n\(appEnv.language.localizedString(item.body))"
    }
}

#Preview {
    NavigationStack {
        HadithDetailView(item: HadithItem(
            title: "Hadith Arba'in 1",
            body: "hadith_featured_body",
            source: "Sahih Bukhari",
            narrator: "Umar bin Al-Khattab",
            category: "hadith_col_arbain",
            arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ"
        ))
    }
}
