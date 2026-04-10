//
//  TarteelAyahRow.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

public struct TarteelAyahRow: View {
    let ayah: QuranAyah
    let result: TarteelResult?
    let isSelected: Bool
    
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(ayah: QuranAyah, result: TarteelResult?, isSelected: Bool) {
        self.ayah = ayah
        self.result = result
        self.isSelected = isSelected
    }
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            // Ayah Number and Status
            HStack {
                if let result = result {
                    HStack(spacing: 6) {
                        Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        Text(result.isCorrect ? "Correct" : "Correction Needed")
                    }
                    .font(.caption.bold())
                    .foregroundColor(result.isCorrect ? .green : .red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background((result.isCorrect ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Text("\(ayah.number)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.primary)
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .stroke(colors.primary.opacity(0.2), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 24)
            
            // Arabic Text with Word-Level Coloring
            if let result = result {
                TarteelFlowLayout(spacing: 8) {
                    ForEach(result.wordResults, id: \.self) { wordResult in
                        Text(wordResult.word)
                            .font(.custom("Amiri-Bold", size: 32))
                            .foregroundColor(wordResult.isCorrect ? .green : .red)
                    }
                }
                .padding(.horizontal, 24)
                .environment(\.layoutDirection, .rightToLeft)
            } else {
                Text(ayah.textArabic)
                    .font(.custom("Amiri-Bold", size: 32))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(colors.foreground)
                    .opacity(0.3)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Feedback Details
            if let result = result, !result.isCorrect || isSelected {
                VStack(alignment: .leading, spacing: 8) {
                    Text(result.feedback)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(result.isCorrect ? .green : .red)
                    
                    if !result.correction.isEmpty {
                        Text(result.correction)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Specific word mistakes
                    let mistakes = result.wordResults.filter { !$0.isCorrect }
                    if !mistakes.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        Text("Specific Word Feedback:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        
                        ForEach(mistakes, id: \.self) { mistake in
                            HStack {
                                Text(mistake.word)
                                    .font(.custom("Amiri-Bold", size: 18))
                                    .foregroundColor(.red)
                                Spacer()
                                Text(mistake.mistake ?? "Unknown error")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.foreground.opacity(0.05))
                )
                .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 8)
        .background(
            isSelected ? colors.primary.opacity(0.03) : Color.clear
        )
    }
}

// Simple TarteelFlowLayout for words
struct TarteelFlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.offsets[index].x, y: bounds.minY + result.offsets[index].y), proposal: ProposedViewSize(result.sizes[index]))
        }
    }
    
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, offsets: [CGPoint], sizes: [CGSize]) {
        var offsets: [CGPoint] = []
        var sizes: [CGSize] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let width = proposal.width ?? .infinity
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            sizes.append(size)
            
            if currentX + size.width > width && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            offsets.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxWidth = max(maxWidth, currentX)
        }
        
        return (CGSize(width: maxWidth, height: currentY + lineHeight), offsets, sizes)
    }
}
