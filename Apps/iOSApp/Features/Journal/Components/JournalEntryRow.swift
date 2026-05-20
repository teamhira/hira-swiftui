//
//  JournalEntryRow.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct JournalEntryRow: View {
    let entry: JournalEntry
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Date Card
            VStack(spacing: 0) {
                Text(entry.formattedDate)
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(colors.primary)
                Text(entry.monthLabel)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.primary.opacity(0.6))
            }
            .frame(width: 54, height: 54)
            .background(colors.primary.opacity(0.1))
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(entry.mood.rawValue)
                        .font(.system(size: 14))
                    Text(entry.title)
                        .font(TextStyle.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(colors.foreground)
                        .lineLimit(1)
                }
                
                Text(entry.preview)
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .lineLimit(2)
                
                if let ref = entry.reference, !ref.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 8))
                        Text(ref)
                            .font(.system(size: 9, weight: .semibold))
                    }
                    .foregroundColor(colors.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(colors.primary.opacity(0.05))
                    .cornerRadius(6)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.2))
        }
        .padding(AppSpacing.md)
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(appEnv.language.localizedString("journal_accessibility_entry", arguments: ["\(entry.formattedDate) \(entry.monthLabel)", entry.title, entry.preview]))
    }
}
