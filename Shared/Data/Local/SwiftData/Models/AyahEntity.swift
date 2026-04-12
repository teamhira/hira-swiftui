//
//  AyahEntity.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import SwiftData

@Model
public final class AyahEntity {
    @Attribute(.unique) public var id: String // surahId:verseNumber
    public var surahId: String
    public var verseNumber: Int
    public var verseKey: String
    public var text: String?
    public var juzNumber: Int?
    public var pageNumber: Int?
    
    @Relationship(deleteRule: .cascade, inverse: \WordEntity.ayah)
    public var words: [WordEntity]?
    
    @Relationship(deleteRule: .cascade, inverse: \TranslationEntity.ayah)
    public var translations: [TranslationEntity]?
    
    // Audio Persistence
    public var audioUrl: String?
    public var audioSegmentsJson: String? // Store [[Int]] as JSON string
    
    // Metadata for cache invalidation
    public var language: String?
    public var translationIdsString: String?
    
    public init(
        id: String,
        surahId: String,
        verseNumber: Int,
        verseKey: String,
        text: String?,
        juzNumber: Int?,
        pageNumber: Int?,
        language: String,
        translationIds: [Int]
    ) {
        self.id = id
        self.surahId = surahId
        self.verseNumber = verseNumber
        self.verseKey = verseKey
        self.text = text
        self.juzNumber = juzNumber
        self.pageNumber = pageNumber
        self.language = language
        self.translationIdsString = translationIds.map(String.init).joined(separator: ",")
    }
    
    // Helper to store/retrieve VerseAudio
    public var verseAudio: VerseAudio? {
        get {
            guard let url = audioUrl else { return nil }
            if let data = audioSegmentsJson?.data(using: .utf8),
               let segments = try? JSONDecoder().decode([[Int]].self, from: data) {
                return VerseAudio(url: url, segments: segments)
            }
            return VerseAudio(url: url, segments: nil)
        }
        set {
            self.audioUrl = newValue?.url
            if let segments = newValue?.segments,
               let data = try? JSONEncoder().encode(segments) {
                self.audioSegmentsJson = String(data: data, encoding: .utf8)
            } else {
                self.audioSegmentsJson = nil
            }
        }
    }
}
