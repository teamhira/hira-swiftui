//
//  Ayah.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct Ayah: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let surahId: String
    public let verseNumber: Int
    public let verseKey: String
    public let text: String?
    public let juzNumber: Int?
    public let pageNumber: Int?
    public let hizbNumber: Int?
    public let rubElHizbNumber: Int?
    public let rukuNumber: Int?
    public let manzilNumber: Int?
    public let chapterId: Int?
    
    // Nested content
    public let words: [Word]?
    public let translations: [Translation]?
    public let audio: VerseAudio?
    
    public init(
        id: String,
        surahId: String,
        verseNumber: Int,
        verseKey: String,
        text: String? = nil,
        juzNumber: Int? = nil,
        pageNumber: Int? = nil,
        hizbNumber: Int? = nil,
        rubElHizbNumber: Int? = nil,
        rukuNumber: Int? = nil,
        manzilNumber: Int? = nil,
        words: [Word]? = nil,
        translations: [Translation]? = nil,
        audio: VerseAudio? = nil,
        chapterId: Int? = nil
    ) {
        self.id = id
        self.surahId = surahId
        self.verseNumber = verseNumber
        self.verseKey = verseKey
        self.text = text
        self.juzNumber = juzNumber
        self.pageNumber = pageNumber
        self.hizbNumber = hizbNumber
        self.rubElHizbNumber = rubElHizbNumber
        self.rukuNumber = rukuNumber
        self.manzilNumber = manzilNumber
        self.words = words
        self.translations = translations
        self.audio = audio
        self.chapterId = chapterId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle ID as Int or String
        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        
        // Handle surahId as Int or String
        if let intSurahId = try? container.decode(Int.self, forKey: .surahId) {
            surahId = String(intSurahId)
        } else {
            surahId = try container.decode(String.self, forKey: .surahId)
        }
        
        verseNumber = try container.decode(Int.self, forKey: .verseNumber)
        verseKey = try container.decode(String.self, forKey: .verseKey)
        text = try? container.decode(String.self, forKey: .text)
        juzNumber = try? container.decode(Int.self, forKey: .juzNumber)
        pageNumber = try? container.decode(Int.self, forKey: .pageNumber)
        hizbNumber = try? container.decode(Int.self, forKey: .hizbNumber)
        rubElHizbNumber = try? container.decode(Int.self, forKey: .rubElHizbNumber)
        rukuNumber = try? container.decode(Int.self, forKey: .rukuNumber)
        manzilNumber = try? container.decode(Int.self, forKey: .manzilNumber)
        chapterId = try? container.decode(Int.self, forKey: .chapterId)
        words = try? container.decode([Word].self, forKey: .words)
        translations = try? container.decode([Translation].self, forKey: .translations)
        audio = try? container.decode(VerseAudio.self, forKey: .audio)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, verseNumber = "verse_number", verseKey = "verse_key", text, juzNumber = "juz_number", pageNumber = "page_number", hizbNumber = "hizb_number", rubElHizbNumber = "rub_el_hizb_number", rukuNumber = "ruku_number", manzilNumber = "manzil_number", chapterId = "chapter_id", words, translations, audio, surahId = "surah_id"
    }
}

public struct VerseAudio: Codable, Equatable, Hashable {
    public let url: String?
    public let segments: [[Int]]?
    
    public init(url: String? = nil, segments: [[Int]]? = nil) {
        self.url = url
        self.segments = segments
    }
}

public struct Word: Codable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let position: Int
    public let text: String?
    public let textTajweed: String?
    public let audioUrl: String?
    public let translation: String?
    public let transliteration: String?
    public let codeV2: String?
    public let pageNumber: Int?
    public let chapterId: Int?
    public let charTypeName: String?
    
    public init(id: Int, position: Int, text: String? = nil, textTajweed: String? = nil, audioUrl: String? = nil, translation: String? = nil, transliteration: String? = nil, codeV2: String? = nil, pageNumber: Int? = nil, chapterId: Int? = nil, charTypeName: String? = nil) {
        self.id = id
        self.position = position
        self.text = text
        self.textTajweed = textTajweed
        self.audioUrl = audioUrl
        self.translation = translation
        self.transliteration = transliteration
        self.codeV2 = codeV2
        self.pageNumber = pageNumber
        self.chapterId = chapterId
        self.charTypeName = charTypeName
    }
    
    enum CodingKeys: String, CodingKey {
        case id, position, text, textTajweed = "text_uthmani_tajweed", audioUrl = "audio_url", translation, transliteration, codeV2 = "code_v2", pageNumber = "page_number", chapterId = "chapter_id", charTypeName = "char_type_name"
    }
}

// MARK: - Preview
extension Ayah {
    public static let preview = Ayah(
        id: "1",
        surahId: "1",
        verseNumber: 1,
        verseKey: "1:1",
        text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        juzNumber: 1,
        pageNumber: 1
    )
}
