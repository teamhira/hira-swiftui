//
//  AyahResponse.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct AyahsResponse: Codable {
    public let verses: [AyahResponse]
    public let pagination: PaginationResponse?
}

public struct SingleAyahResponse: Codable {
    public let verse: AyahResponse
}

public struct AyahResponse: Codable {
    public let id: Int
    public let verseNumber: Int
    public let verseKey: String
    public let textUthmani: String?
    public let textIndopak: String?
    public let textImlaei: String?
    public let juzNumber: Int
    public let hizbNumber: Int
    public let rubElHizbNumber: Int
    public let rukuNumber: Int
    public let manzilNumber: Int
    public let pageNumber: Int
    public let chapterId: Int?
    
    // Nested data
    public let words: [WordResponse]?
    public let translations: [TranslationDataResponse]?
    public let audio: VerseAudioResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, words, translations, audio
        case verseNumber = "verse_number"
        case verseKey = "verse_key"
        case textUthmani = "text_uthmani"
        case textIndopak = "text_indopak"
        case textImlaei = "text_imlaei"
        case juzNumber = "juz_number"
        case hizbNumber = "hizb_number"
        case rubElHizbNumber = "rub_el_hizb_number"
        case rukuNumber = "ruku_number"
        case manzilNumber = "manzil_number"
        case pageNumber = "page_number"
        case chapterId = "chapter_id"
    }
    
    func toDomain(surahId: String) -> Ayah {
        return Ayah(
            id: String(id),
            surahId: surahId,
            verseNumber: verseNumber,
            verseKey: verseKey,
            text: textUthmani ?? textIndopak ?? textImlaei ?? words?.compactMap { $0.textUthmani ?? $0.textIndopak }.joined(separator: " "),
            juzNumber: juzNumber,
            pageNumber: pageNumber,
            hizbNumber: hizbNumber,
            rubElHizbNumber: rubElHizbNumber,
            rukuNumber: rukuNumber,
            manzilNumber: manzilNumber,
            words: words?.map { $0.toDomain() },
            translations: translations?.map { $0.toDomain() },
            audio: audio?.toDomain(),
            chapterId: chapterId
        )
    }
}

public struct WordResponse: Codable {
    public let id: Int
    public let position: Int
    public let textUthmani: String?
    public let textUthmaniTajweed: String?
    public let textIndopak: String?
    public let codeV1: String?
    public let codeV2: String?
    public let pageNumber: Int?
    public let chapterId: Int?
    public let charTypeName: String?
    public let audioUrl: String?
    public let translation: WordTranslationResponse? 
    public let transliteration: TransliterationInfoResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, position, translation, transliteration
        case textUthmani = "text_uthmani"
        case textUthmaniTajweed = "text_uthmani_tajweed"
        case textIndopak = "text_indopak"
        case codeV1 = "code_v1"
        case codeV2 = "code_v2"
        case pageNumber = "page_number"
        case chapterId = "chapter_id"
        case charTypeName = "char_type_name"
        case audioUrl = "audio_url"
    }
    
    func toDomain() -> Word {
        return Word(
            id: id,
            position: position,
            text: textUthmani ?? textIndopak,
            textTajweed: textUthmaniTajweed,
            audioUrl: audioUrl,
            translation: translation?.text,
            transliteration: transliteration?.text,
            codeV2: codeV2,
            pageNumber: pageNumber,
            chapterId: chapterId,
            charTypeName: charTypeName
        )
    }
}

public struct TransliterationInfoResponse: Codable {
    public let text: String?
    public let languageName: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case languageName = "language_name"
    }
}

public struct WordTranslationResponse: Codable {
    public let text: String?
    public let languageName: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case languageName = "language_name"
    }
}

public struct VerseAudioResponse: Codable {
    public let url: String?
    public let segments: [[Int]]?
    
    func toDomain() -> VerseAudio {
        return VerseAudio(url: url, segments: segments)
    }
}
