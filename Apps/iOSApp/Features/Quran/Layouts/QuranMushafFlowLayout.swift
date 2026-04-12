//
//  QuranMushafFlowLayout.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

struct QuranMushafFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(ProposedViewSize(width: width, height: nil))
            
            // New row logic: if full width item or exceeds current line
            if (size.width >= width || currentX + size.width > width) && currentX > 0 {
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            
            maxRowWidth = max(maxRowWidth, size.width)
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
        }

        return CGSize(width: width == .infinity ? maxRowWidth : width, height: currentY + maxRowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = bounds.width
        var rows: [[LayoutSubviews.Element]] = [[]]
        var currentRowWidth: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if (size.width >= width || currentRowWidth + size.width > width) && !rows[rows.count - 1].isEmpty {
                rows.append([subview])
                currentRowWidth = size.width + spacing
            } else {
                rows[rows.count - 1].append(subview)
                currentRowWidth += size.width + spacing
            }
        }
        
        var currentY = bounds.minY
        
        for (index, row) in rows.enumerated() {
            let isLastRow = index == rows.count - 1
            let rowSubviewsWidth = row.reduce(0) { $0 + $1.sizeThatFits(.unspecified).width }
            
            // Justification logic
            let totalSpacing = width - rowSubviewsWidth
            let actualSpacing = (row.count > 1 && !isLastRow) ? totalSpacing / CGFloat(row.count - 1) : spacing
            
            var currentX = bounds.minX // Logical START
            var maxRowHeight: CGFloat = 0
            
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                if size.width >= width {
                    subview.place(at: CGPoint(x: bounds.minX, y: currentY), proposal: ProposedViewSize(width: width, height: nil))
                    maxRowHeight = size.height
                } else {
                    // Place from Leading to Trailing
                    subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
                    currentX += (size.width + actualSpacing)
                    maxRowHeight = max(maxRowHeight, size.height)
                }
            }
            currentY += maxRowHeight + spacing
        }
    }
}
