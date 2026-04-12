//
//  QuranNavigationIndicator.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranNavigationIndicator: View {
    let offset: CGFloat
    let isTop: Bool
    let targetSurah: Surah
    let colors: ThemeModel
    
    var body: some View {
        Group {
            if abs(offset) > 1 {
                VStack(spacing: 8) {
                    targetInfo
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var targetInfo: some View {
        VStack(spacing: 4) {
            Text(targetSurah.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colors.primary)
            
            Text(isTop ? "Switching to previous..." : "Switching to next surah...")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(colors.primary.opacity(0.6))
        }
        .opacity(abs(offset) > 5 ? 1 : 0)
    }
}
