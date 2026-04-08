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
    
    let title: String
    let arabicText: String
    let transliteration: String
    let translation: String
    let reference: String?
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Main Card Container with content
                    VStack(spacing: 32) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey(title))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            
                            Divider()
                        }
                        
                        // Arabic Section with RTL formatting
                        VStack(alignment: .trailing, spacing: 16) {
                            HStack {
                                Image(systemName: "character.book.closed.fill")
                                    .foregroundColor(colors.primary)
                                Text(LocalizedStringKey("dua_item_arabic_label"))
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text(arabicText)
                                .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 32))
                                .lineSpacing(12)
                                .multilineTextAlignment(.trailing)
                                .environment(\.layoutDirection, .rightToLeft)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(colors.foreground)
                        }
                        .padding(20)
                        .background(colors.primary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                        // Transliteration Section (Optional)
                        if !transliteration.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(transliteration)
                                    .font(.system(size: 16, weight: .medium, design: .serif))
                                    .italic()
                                    .foregroundColor(colors.primary.opacity(0.8))
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Translation Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text(LocalizedStringKey("dua_item_translation_label"))
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            Text(translation)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(colors.foreground.opacity(0.9))
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Reference Section
                        if let reference = reference, !reference.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(colors.primary.opacity(0.4))
                                Text(reference)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                        }
                        
                        // Share Actions
                        HStack(spacing: 16) {
                            Button(action: shareDua) {
                                Label("Share", systemImage: "square.and.arrow.up")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(colors.primary)
                                    .clipShape(Capsule())
                            }
                            
                            Button(action: copyDua) {
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
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Actions
    private func shareDua() {
        // Logic to share the dua
    }
    
    private func copyDua() {
        UIPasteboard.general.string = "\(arabicText)\n\n\(translation)"
    }
}

#Preview {
    NavigationStack {
        DuaDetailView(
            title: "Dua for Morning",
            arabicText: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Bismillaahil-ladhee laa yadurru ma'as-mishi shay'un fil-ardi wa laa fis-samaa'i wa Huwas-Samee 'ul-'Aleem",
            translation: "In the Name of Allah, who with His Name nothing can cause harm in the earth nor in the heavens, and He is the All-Hearing, the All-Knowing.",
            reference: "Sunan Abu Dawud"
        )
    }
}
