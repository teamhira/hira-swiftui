//
//  HijriMonthInfoCard.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct HijriMonthInfoCard: View {
    let month: UmmahIslamicMonth
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("\(month.id)")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(colors.primary.opacity(0.1))
                    .overlay {
                        Text("\(month.id)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors.primary)
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(month.name)
                        .font(TextStyle.headline)
                        .foregroundColor(colors.foreground)
                    Text(month.nameArabic)
                        .font(.system(size: 12))
                        .foregroundColor(colors.primary)
                }
                
                Spacer()
            }

            
            if let significance = month.significance {
                Text(significance)
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.7))
                    .padding(AppSpacing.sm)
                    .background(colors.background)
                    .cornerRadius(12)
            }
        }
        .padding(AppSpacing.md)
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }
}
