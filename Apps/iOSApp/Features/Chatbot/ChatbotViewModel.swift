//
//  ChatbotViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation

@Observable
public class ChatbotViewModel {
    public var currentSession: ChatSession
    public var sessions: [ChatSession] = []
    public var currentInput: String = ""
    public var isTyping: Bool = false
    
    private let sessionsKey = "hira_chat_sessions"
    
    public init() {
        // Load sessions from storage
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([ChatSession].self, from: data) {
            self.sessions = decoded
        }
        
        // Start with a clean session
        self.currentSession = ChatSession(title: "New Chat")
        addWelcomeMessage()
    }
    
    private func addWelcomeMessage() {
        currentSession.messages.append(ChatMessage(
            text: "Assalamu'alaikum! I'm your Hira assistant. You can use /surah:1 or /hadith:1 for quick references.",
            isUser: false
        ))
    }
    
    public func sendMessage() {
        let trimmedInput = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        // Parse for commands
        let metadata = parseCommand(trimmedInput)
        
        let userMsg = ChatMessage(text: trimmedInput, isUser: true, metadata: metadata)
        currentSession.messages.append(userMsg)
        currentSession.lastModified = Date()
        
        // Update session title if it's the first message
        if currentSession.messages.count <= 2 {
            currentSession.title = trimmedInput.prefix(30).appending("...")
        }
        
        currentInput = ""
        isTyping = true
        
        // Mock response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.generateResponse(to: userMsg)
        }
    }
    
    private func parseCommand(_ input: String) -> ChatMetadata? {
        if input.starts(with: "/surah:") {
            let value = input.replacingOccurrences(of: "/surah:", with: "")
            return ChatMetadata(referenceType: "quran", referenceValue: "Surah \(value)", previewContent: "Ref: Surah \(value)")
        } else if input.starts(with: "/hadith:") {
            let value = input.replacingOccurrences(of: "/hadith:", with: "")
            return ChatMetadata(referenceType: "hadith", referenceValue: "Hadith \(value)", previewContent: "Narrated by Prophet SAW...")
        }
        return nil
    }
    
    private func generateResponse(to message: ChatMessage) {
        self.isTyping = false
        
        var responseText = "I see. Let me help you with that. "
        var metadata: ChatMetadata? = nil
        
        if let userMeta = message.metadata {
            if userMeta.referenceType == "quran" {
                responseText = "Here is the Quranic reference for \(userMeta.referenceValue ?? "your inquiry")."
                metadata = ChatMetadata(referenceType: "tafsir", referenceValue: "Tafsir Ibn Kathir", previewContent: "Indeed, Allah is with the patient...")
            } else if userMeta.referenceType == "hadith" {
                responseText = "Found it! This hadith emphasizes the importance of good character."
            }
        } else {
            responseText = "That's a profound thought. How else can I assist your journey today?"
        }
        
        let aiMsg = ChatMessage(text: responseText, isUser: false, metadata: metadata)
        currentSession.messages.append(aiMsg)
        saveSessions()
    }
    
    public func saveCurrentSession() {
        if let index = sessions.firstIndex(where: { $0.id == currentSession.id }) {
            sessions[index] = currentSession
        } else {
            sessions.insert(currentSession, at: 0)
        }
        saveSessions()
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    public func startNewSession() {
        saveCurrentSession()
        currentSession = ChatSession(title: "New Chat")
        addWelcomeMessage()
    }
    
    public func loadSession(_ session: ChatSession) {
        saveCurrentSession()
        currentSession = session
    }
    
    public func deleteSession(_ session: ChatSession) {
        sessions.removeAll(where: { $0.id == session.id })
        saveSessions()
        
        if currentSession.id == session.id {
            startNewSession()
        }
    }
}
