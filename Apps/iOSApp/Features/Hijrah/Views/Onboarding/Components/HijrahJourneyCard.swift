//
//  HijrahJourneyCard.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct HijrahJourneyCard: View {
    let type: JourneyType
    let title: String
    let desc: String
    let icon: String
    let isSelected: Bool
    let colors: ThemeModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(isSelected ? colors.primary : colors.foreground.opacity(0.05))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : colors.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.bold())
                        .foregroundColor(isSelected ? colors.primary : colors.foreground)
                    
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? colors.primary.opacity(0.8) : .secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isSelected ? colors.primary.opacity(0.08) : colors.background)
                    .hiraCleanCard(colors: colors, radius: 24)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isSelected ? colors.primary : Color.clear, lineWidth: 2.5)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
