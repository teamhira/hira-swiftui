//
//  KhatamHistoryRow.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct KhatamHistoryRow: View {
    let record: KhatamHistoryRecord
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(colors.primary)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(record.title)
                    .font(TextStyle.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("khatam_completed_on", arguments: [formatDate(record.completedDate)]))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
            }
            
            Spacer()
            
            Text(appEnv.language.localizedString("khatam_ayah_count", arguments: [record.totalAyahs]))
                .font(TextStyle.footnote)
                .fontWeight(.black)
                .foregroundColor(colors.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(colors.primary.opacity(0.1))
                .clipShape(Capsule())

        }
        .padding(AppSpacing.md)
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }

    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
