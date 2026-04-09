//
//  QuranHeritageHeader.swift
//  Hira
//
//  Created by Antigravity on 08/04/26.
//

import SwiftUI

struct QuranHeritageHeader: View {
    let surah: Surah
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            // Heritage Border
            RoundedRectangle(cornerRadius: 12)
                .stroke(colors.primary.opacity(0.3), lineWidth: 1)
                .background(colors.primary.opacity(0.03))
            
            HStack(spacing: 16) {
                Image(systemName: "seal")
                    .font(.system(size: 18))
                    .foregroundColor(colors.primary.opacity(0.4))
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text(surah.nameArabic)
                        .font(.custom("KFGQPC Uthman Taha Naskh", size: 36))
                        .foregroundColor(colors.primary)
                }
                
                Spacer()
                
                Image(systemName: "seal")
                    .font(.system(size: 18))
                    .foregroundColor(colors.primary.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .frame(height: 72)
    }
}
