//
//  HalalPlaceListItem.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// A row component representing a single Halal place in a list view.
struct HalalPlaceListItem: View {
    // MARK: - Properties
    let place: HalalPlace
    let colors: ThemeModel
    var onDirections: () -> Void = {}
    var onTap: () -> Void = {}

    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // MARK: - Visual Indicator
                ZStack {
                    colors.primary.opacity(0.1)
                    Image(systemName: "fork.knife")
                        .font(.title3)
                        .foregroundColor(colors.primary)
                }
                .frame(width: 52, height: 52)
                .cornerRadius(16)
                
                // MARK: - Place Metadata
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(place.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(colors.foreground)
                            .lineLimit(1)
                        
                        if place.isOpen {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    Text(place.address)
                        .font(.system(size: 12))
                        .foregroundColor(colors.foreground.opacity(0.5))
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", place.rating))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(colors.foreground)
                        }
                        
                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(colors.foreground.opacity(0.2))
                        
                        Text(formattedDistance)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(colors.primary)
                    }
                }
                
                Spacer()
                
                // MARK: - Shortcut Action
                Button(action: onDirections) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(colors.primary)
                        .padding(10)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Computed Properties
    private var formattedDistance: String {
        if place.distance >= 1000 {
            return String(format: "%.1f km", Double(place.distance) / 1000.0)
        } else {
            return "\(place.distance) m"
        }
    }
}
