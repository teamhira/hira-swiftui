//
//  ChatHistoryRow.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct ChatHistoryRow: View {
    let session: ChatSession
    let colors: ThemeModel
    let onDelete: () -> Void
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundColor(colors.primary)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(TextStyle.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text("\(session.messages.count) messages • \(formatDate(session.lastModified))")
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red.opacity(0.6))
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.2))
        }
        .padding(AppSpacing.md)
        .background(colors.card)
        .cornerRadius(16)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
