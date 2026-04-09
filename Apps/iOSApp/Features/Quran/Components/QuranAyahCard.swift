//
//  QuranAyahCard.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranAyahCard: View {
    let ayah: QuranAyah
    let viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        let colors = appEnv.theme.current
        let isActive = viewModel.activeAyah?.number == ayah.number
        
        VStack(alignment: .trailing, spacing: 16) {
            // Arabic Text with Numbering
            HStack(alignment: .top, spacing: 12) {
                Spacer()
                Text("﴾\(String(ayah.number).convertedToArabic())﴿ \(ayah.textArabic)")
                    .font(.custom("KFGQPC Uthman Taha Naskh", size: 30))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(colors.foreground)
                    .lineSpacing(10)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                // Transliteration
                Text(ayah.textLatin)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(colors.primary.opacity(0.8))
                    .italic()
                    .multilineTextAlignment(.leading)
                
                // Translation
                Text(ayah.translation)
                    .font(.system(size: 15))
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
        .background(
            ZStack(alignment: .leading) {
                if isActive {
                    colors.primary.opacity(0.08)
                    
                    // Active Indicator Bar on the far left
                    Rectangle()
                        .fill(colors.primary)
                        .frame(width: 4)
                } else {
                    colors.background
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            viewModel.selectedAyah = ayah
            viewModel.showingAyahOptions = true
        }
        .onTapGesture(count: 1) {
            withAnimation(.spring()) {
                viewModel.activeAyah = ayah
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
