//
//  HalalFoodListItem.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// A clean list row for food products within the Halal Finder feature.
public struct HalalFoodListItem: View {
    // MARK: - Properties
    public let food: HalalFood
    public let colors: ThemeModel
    public var onTap: () -> Void = {}
    
    // MARK: - Body
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // MARK: - Image Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.primary.opacity(0.05))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "tag.fill")
                        .font(.title3)
                        .foregroundColor(colors.primary.opacity(0.3))
                }
                
                // MARK: - Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colors.foreground)
                    
                    Text(food.brand)
                        .font(.system(size: 13))
                        .foregroundColor(colors.foreground.opacity(0.5))
                }
                
                Spacer()
                
                // MARK: - Status Badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 6, height: 6)
                    
                    Text(food.status)
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(statusColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor.opacity(0.1))
                .cornerRadius(20)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Computed Properties
    private var statusColor: Color {
        switch food.status {
        case "Certified": return .green
        case "Pending": return .orange
        case "Doubtful": return .red
        default: return .gray
        }
    }
}
