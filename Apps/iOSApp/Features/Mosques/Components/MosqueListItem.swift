//
//  MosqueListItem.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct MosqueListItem: View {
    // MARK: - Properties
    let mosque: MosqueItem
    let colors: ThemeModel
    var onDirections: () -> Void = {}
    var onTap: () -> Void = {}

    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // MARK: - Mosque Thumbnail
                ZStack {
                    colors.primary.opacity(0.1)
                    Image(systemName: "building.2.fill")
                        .font(.title3)
                        .foregroundColor(colors.primary)
                }
                .frame(width: 52, height: 52)
                .cornerRadius(16)
                
                // MARK: - Mosque Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(mosque.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(colors.foreground)
                            .lineLimit(1)
                        
                        if mosque.isOpen {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    Text(mosque.address)
                        .font(.system(size: 12))
                        .foregroundColor(colors.foreground.opacity(0.5))
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", mosque.rating))
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
                
                // MARK: - Direct Action
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
        if mosque.distance >= 1000 {
            return String(format: "%.1f km", Double(mosque.distance) / 1000.0)
        } else {
            return "\(mosque.distance) m"
        }
    }
}





