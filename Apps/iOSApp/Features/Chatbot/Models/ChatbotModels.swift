//
//  ChatbotModels.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import Foundation

public struct ChatMessage: Identifiable, Codable, Hashable {
    public let id: UUID
    public let text: String
    public let isUser: Bool
    public let timestamp: Date
    public var metadata: ChatMetadata?
    
    public init(id: UUID = UUID(), text: String, isUser: Bool, timestamp: Date = Date(), metadata: ChatMetadata? = nil) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

public struct ChatMetadata: Codable, Hashable {
    public var referenceType: String? // "quran", "hadith", "tafsir"
    public var referenceValue: String? // "1:1", "Bukhari:1"
    public var previewContent: String?
}

public struct ChatSession: Identifiable, Codable, Hashable {
    public let id: UUID
    public var title: String
    public var messages: [ChatMessage]
    public let createdAt: Date
    public var lastModified: Date
    
    public init(id: UUID = UUID(), title: String, messages: [ChatMessage] = [], createdAt: Date = Date(), lastModified: Date = Date()) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdAt = createdAt
        self.lastModified = lastModified
    }
}
