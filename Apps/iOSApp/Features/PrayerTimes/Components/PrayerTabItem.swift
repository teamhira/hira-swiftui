//
//  PrayerTabItem.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

struct PrayerTabItem: View {
    let title: String
    let isSelected: Bool
    let colors: ThemeModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(isSelected ? TextStyle.headline : TextStyle.subheadline)
                .foregroundColor(isSelected ? .white : .secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            Capsule()
                                .fill(LinearGradient(colors: [colors.primary, colors.primary.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: colors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                )
        }
        .frame(maxWidth: .infinity)
    }
}
