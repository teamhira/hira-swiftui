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
    @State private var viewModel = ChatbotViewModel()
    @State private var showHistory = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat area
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.currentSession.messages) { message in
                            ChatBubble(message: message, colors: colors)
                                .id(message.id)
                        }
                        
                        if viewModel.isTyping {
                            TypingIndicator(colors: colors)
                                .id("typing")
                        }
                    }
                    .padding(AppSpacing.md)
                }
                .background(colors.background)
                .onChange(of: viewModel.currentSession.messages) { _, _ in
                    scrollToBottom(proxy: proxy)
                }
            }
            
            // Input Area
            ChatInputArea(text: $viewModel.currentInput, colors: colors) {
                viewModel.sendMessage()
            }
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
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: { 
                        withAnimation {
                            viewModel.startNewSession() 
                        }
                    }) {
                        Image(systemName: "plus.bubble.fill")
                            .foregroundColor(colors.primary)
                    }
                    
                    Button(action: { showHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(colors.primary)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showHistory) {
            ChatHistoryView(viewModel: viewModel, colors: colors)
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
            if viewModel.isTyping {
                proxy.scrollTo("typing", anchor: .bottom)
            } else if let lastMessage = viewModel.currentSession.messages.last {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatbotView()
            .environment(AppRouter())
            .environment(AppState())
    }
}
