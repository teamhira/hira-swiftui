//
//  BookmarkComponents.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct BookmarkHeaderCard: View {
    let count: Int
    let lastRead: String
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 56, height: 56)
                Image(systemName: "bookmark.fill")
                    .font(.title3)
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(appEnv.language.localizedString("quran_bookmark_header_title"))
                    .font(.system(size: 18, weight: .bold))
                Text(String(format: appEnv.language.localizedString("quran_bookmark_count"), count))
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                Text(lastRead)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            Spacer()
        }
        .padding(24)
        .hiraCleanCard(colors: colors, radius: 28)
    }
}

public struct BookmarkRowView: View {
    let bookmark: QuranBookmark
    var onDelete: (() -> Void)? = nil
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(bookmark.surahName ?? "Surah \(bookmark.surahNumber)")
                        .font(.subheadline.bold())
                    if let nameArabic = bookmark.surahNameArabic {
                        Text(nameArabic).font(.caption).foregroundColor(colors.primary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: appEnv.language.localizedString("quran_ayah_ref"), bookmark.ayahNumber))
                        .font(.subheadline.bold())
                    Text(String(format: appEnv.language.localizedString("quran_time_ago"), bookmark.timeAgo))
                        .font(.system(size: 10))
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
                
                if let onDelete = onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                } else {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(colors.primary)
                        .font(.caption)
                        .padding(8)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            if let arabicText = bookmark.arabicText {
                Text(arabicText)
                    .font(.custom("KFGQPC Uthman Taha Naskh", size: 22))
                    .multilineTextAlignment(.trailing)
                    .lineSpacing(10)
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(colors.primary.opacity(0.03))
                    )
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 10)  // Increased for full shadow visibility
        .padding(.vertical, 4)
        .hiraCleanCard(colors: colors, radius: 26)
    }
}
