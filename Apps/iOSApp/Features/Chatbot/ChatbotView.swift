//
//  ChatbotView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct ChatbotView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var viewModel = ChatbotViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Room chat area
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.messages) { message in
                        ChatBubble(message: message, colors: colors)
                    }
                    if viewModel.isTyping {
                        TypingIndicator(colors: colors)
                    }
                }
                .padding(24)
            }
            .background(colors.background)
            
            // Input Area
            HStack(spacing: 12) {
                TextField(appEnv.language.localizedString("chatbot_input_placeholder"), text: $viewModel.currentInput)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(colors.foreground.opacity(0.04))
                    .cornerRadius(25)
                    .onSubmit { viewModel.sendMessage() }
                
                Button(action: { viewModel.sendMessage() }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(colors.primary)
                        .clipShape(Circle())
                }
            }
            .padding(16)
            .background(colors.background)
            .shadow(color: colors.foreground.opacity(0.05), radius: 10, y: -5)
        }
        .navigationTitle(appEnv.language.localizedString("chatbot_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { router.pop() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Subviews
private struct ChatBubble: View {
    let message: ChatMessage
    let colors: ThemeModel
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .font(.subheadline)
                .padding(16)
                .background(message.isUser ? colors.primary : colors.foreground.opacity(0.05))
                .foregroundColor(message.isUser ? .white : colors.foreground)
                .cornerRadius(20, corners: message.isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}

private struct TypingIndicator: View {
    let colors: ThemeModel
    @State private var dotScale: CGFloat = 0.5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(colors.primary.opacity(0.5))
                    .frame(width: 6, height: 6)
                    .scaleEffect(dotScale)
                    .animation(.easeInOut(duration: 0.5).repeatForever().delay(Double(i) * 0.15), value: dotScale)
            }
        }
        .padding(12)
        .background(colors.foreground.opacity(0.05))
        .cornerRadius(12)
        .onAppear { dotScale = 1.0 }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        ChatbotView()
            .environment(AppRouter())
            .environment(AppState())
    }
}
