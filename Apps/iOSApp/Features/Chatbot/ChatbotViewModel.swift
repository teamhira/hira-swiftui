//
//  ChatbotViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation

public struct ChatMessage: Identifiable, Hashable {
    public let id = UUID()
    public let text: String
    public let isUser: Bool
    public let timestamp = Date()
}

@Observable
public class ChatbotViewModel {
    public var messages: [ChatMessage] = []
    public var currentInput: String = ""
    public var isTyping: Bool = false
    
    public init() {
        // Initial welcome message
        messages.append(ChatMessage(text: "Assalamu'alaikum! I'm here to help you with your journey in Hira.", isUser: false))
    }
    
    public func sendMessage() {
        guard !currentInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMsg = ChatMessage(text: currentInput, isUser: true)
        messages.append(userMsg)
        
        currentInput = ""
        isTyping = true
        
        // Dummy response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isTyping = false
            self.messages.append(ChatMessage(text: "That sounds like a great step in your journey. Let me know if you need more guidance!", isUser: false))
        }
    }
}
