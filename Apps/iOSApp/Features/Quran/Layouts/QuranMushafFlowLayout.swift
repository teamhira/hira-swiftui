//
//  QuranMushafFlowLayout.swift
//  Hira
//
//  Created by Antigravity on 08/04/26.
//

import SwiftUI

struct QuranMushafFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > width {
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            maxRowWidth = max(maxRowWidth, currentX + size.width)
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
            totalHeight = currentY + maxRowHeight
        }

        return CGSize(width: maxRowWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = bounds.width
        var rows: [[LayoutSubviews.Element]] = [[]]
        var currentRowWidth: CGFloat = 0
        
        // Group subviews into rows
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > width && !rows[rows.count - 1].isEmpty {
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
            let totalAvailableWidth = width
            let totalSpacing = totalAvailableWidth - rowSubviewsWidth
            
            // For justification: if not the last row and has more than 1 item, stretch spacing
            let rowSpacing = (row.count > 1 && !isLastRow) ? totalSpacing / CGFloat(row.count - 1) : spacing
            
            var currentX = bounds.maxX
            var maxRowHeight: CGFloat = 0
            
            // Standard spacing for the last row (right alignment)
            let actualSpacing = (row.count > 1 && !isLastRow) ? rowSpacing : spacing
            
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: currentX - size.width, y: currentY), proposal: .unspecified)
                currentX -= (size.width + actualSpacing)
                maxRowHeight = max(maxRowHeight, size.height)
            }
            
            currentY += maxRowHeight + spacing
        }
    }
}
