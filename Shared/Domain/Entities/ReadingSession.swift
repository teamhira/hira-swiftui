//
//  ReadingSession.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation

public struct ReadingSessionEntity: Identifiable, Codable, Hashable {
    public let id: String
    public let updatedAt: Date
    public let chapterNumber: Int
    public let verseNumber: Int
    
    public init(id: String, updatedAt: Date, chapterNumber: Int, verseNumber: Int) {
        self.id = id
        self.updatedAt = updatedAt
        self.chapterNumber = chapterNumber
        self.verseNumber = verseNumber
    }
}

// MARK: - API Models

public struct ReadingSessionsResponse: Codable {
    public let success: Bool
    public let data: [ReadingSessionModel]?
    public let pagination: ReadingSessionPagination?
}

public struct ReadingSessionPostResponse: Codable {
    public let success: Bool
    public let data: ReadingSessionPostData?
}

public struct ReadingSessionPostData: Codable {
    public let message: String
}

public struct ReadingSessionModel: Codable {
    public let id: String
    public let updatedAt: String
    public let chapterNumber: Int
    public let verseNumber: Int
    
    public func toEntity() -> ReadingSessionEntity {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: updatedAt) ?? Date()
        
        return ReadingSessionEntity(
            id: id,
            updatedAt: date,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber
        )
    }
}

public struct ReadingSessionPagination: Codable {
    public let startCursor: String?
    public let endCursor: String?
    public let hasNextPage: Bool
    public let hasPreviousPage: Bool
}
