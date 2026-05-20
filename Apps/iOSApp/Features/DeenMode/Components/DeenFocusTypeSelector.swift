//
//  DeenFocusTypeSelector.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct DeenFocusTypeSelector: View {
    @Binding var selectedType: DeenFocusType
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ForEach(DeenFocusType.allCases) { type in
                Button(action: { selectedType = type }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(selectedType == type ? colors.primary : colors.foreground.opacity(0.05))
                                .frame(width: 54, height: 54)
                            
                            Image(systemName: type.icon)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(selectedType == type ? .white : colors.foreground.opacity(0.4))
                        }
                        
                        Text(appEnv.language.localizedString(type.titleKey))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(selectedType == type ? colors.primary : colors.foreground.opacity(0.4))
                            .textCase(.uppercase)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }
}
