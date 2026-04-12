//
//  QuranFlowLayout.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI

public struct QuranFlowLayout: Layout {
    public var spacing: CGFloat
    public var alignment: Alignment = .trailing

    public init(spacing: CGFloat, alignment: Alignment = .trailing) {
        self.spacing = spacing
        self.alignment = alignment
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let width = proposal.width ?? .infinity
        
        for (_, size) in sizes.enumerated() {
            if currentX + size.width > width && currentX > 0 {
                // Remove trailing spacing from previous maxRow calculation before wrapping
                maxWidth = max(maxWidth, currentX - spacing)
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
            maxWidth = max(maxWidth, currentX - spacing)
        }
        
        return CGSize(width: maxWidth, height: currentY + maxRowHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = bounds.width
        var rows: [[LayoutSubviews.Element]] = [[]]
        var currentRowWidth: CGFloat = 0
        
        // 1. Group subviews into rows
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > width && !rows[rows.count - 1].isEmpty {
                rows.append([subview])
                currentRowWidth = size.width + spacing
            } else {
                rows[rows.count - 1].append(subview)
                currentRowWidth += (size.width + spacing)
            }
        }
        
        // 2. Place each row from Leading to Trailing (Respecting RTL environment)
        var currentY = bounds.minY
        for row in rows {
            var currentX = bounds.minX // Logical START (In RTL this is physically Right)
            var maxRowHeight: CGFloat = 0
            
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                // Position at current logical X
                subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
                
                // Advance logical x
                currentX += (size.width + spacing)
                maxRowHeight = max(maxRowHeight, size.height)
            }
            
            currentY += (maxRowHeight + spacing)
        }
    }
}
