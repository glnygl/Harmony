//
//  FlowLayout.swift
//  Harmony
//
//  Created by Glny Gl on 10/02/2025.
//

import SwiftUI

struct FlowLayout: Layout {
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return CGSize(width: proposal.width ?? result.width, height: result.height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        
        var x = bounds.minX
        var y = bounds.minY
        
        for row in result.rows {
            x = bounds.minX
            
            for index in row {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(size)
                )
                x += size.width + spacing
            }
            
            y += result.rowHeight + spacing
        }
    }
    
    struct FlowResult {
        var width: CGFloat = 0
        var height: CGFloat = 0
        var rowHeight: CGFloat = 0
        var rows: [[Int]] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentRow: [Int] = []
            var x: CGFloat = 0
            var y: CGFloat = 0
            var maxRowHeight: CGFloat = 0
            
            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && !currentRow.isEmpty {
                    rows.append(currentRow)
                    currentRow = []
                    x = 0
                    y += maxRowHeight + spacing
                    maxRowHeight = 0
                }
                
                currentRow.append(index)
                x += size.width + spacing
                width = max(width, x)
                maxRowHeight = max(maxRowHeight, size.height)
            }
            
            if !currentRow.isEmpty {
                rows.append(currentRow)
                y += maxRowHeight
            }
            
            self.rowHeight = maxRowHeight
            self.height = y
        }
    }
}
