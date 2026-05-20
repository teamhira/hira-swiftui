//
//  ChatBubble.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
            HStack {
                if message.isUser { Spacer() }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(message.text)
                        .font(TextStyle.subheadline)
                        .foregroundColor(message.isUser ? .white : colors.foreground)
                    
                    if let metadata = message.metadata {
                        referenceView(metadata)
                    }
                }
                .padding(16)
                .background(message.isUser ? colors.primary : colors.card)
                .cornerRadius(20, corners: message.isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
                .frame(maxWidth: 300, alignment: message.isUser ? .trailing : .leading)
                
                if !message.isUser { Spacer() }
            }
            
            Text(formatTime(message.timestamp))
                .font(.system(size: 10))
                .foregroundColor(colors.foreground.opacity(0.4))
                .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    private func referenceView(_ metadata: ChatMetadata) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
                .background(message.isUser ? Color.white.opacity(0.3) : colors.foreground.opacity(0.1))
            
            HStack(spacing: 8) {
                Image(systemName: metadata.referenceType == "quran" ? "book.fill" : "quote.bubble.fill")
                    .font(.system(size: 14))
                    .foregroundColor(message.isUser ? .white : colors.primary)
                
                Text(appEnv.language.localizedString("chatbot_ref_") + (metadata.referenceType ?? ""))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(message.isUser ? .white : colors.primary)
            }
            
            if let content = metadata.previewContent {
                Text(content)
                    .font(.system(size: 12, weight: .medium))
                    .italic()
                    .foregroundColor(message.isUser ? .white.opacity(0.9) : colors.foreground.opacity(0.7))
                    .lineLimit(3)
            }
            
            if let value = metadata.referenceValue {
                Text(value)
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(message.isUser ? .white.opacity(0.7) : colors.foreground.opacity(0.5))
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
