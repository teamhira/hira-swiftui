//
//  SettingsResourceResponses.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation

public struct TafsirResponse: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let authorName: String?
    public let languageName: String
    public let translatedName: TranslatedName
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case authorName = "author_name"
        case languageName = "language_name"
        case translatedName = "translated_name"
    }
}

public struct TafsirResourceResponse: Codable {
    public let tafsirs: [TafsirResponse]
}

public struct RecitationResponse: Codable, Identifiable {
    public let id: Int
    public let reciterName: String
    public let style: String?
    public let translatedName: TranslatedName
    
    enum CodingKeys: String, CodingKey {
        case id, style
        case reciterName = "reciter_name"
        case translatedName = "translated_name"
    }
}

public struct RecitationsResponse: Codable {
    public let recitations: [RecitationResponse]
}

public struct SingleRecitationResponse: Codable {
    public let recitation: RecitationResponse
}

public struct TranslationResourceResponse: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let authorName: String?
    public let languageName: String
    public let translatedName: TranslatedName
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case authorName = "author_name"
        case languageName = "language_name"
        case translatedName = "translated_name"
    }
}

public struct TranslationResourcesResponse: Codable {
    public let translations: [TranslationResourceResponse]
}

public struct LanguageResponse: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let isoCode: String
    public let nativeName: String
    public let direction: String?
    public let translationsCount: Int?
    public let translatedName: TranslatedName
    
    enum CodingKeys: String, CodingKey {
        case id, name, direction
        case isoCode = "iso_code"
        case nativeName = "native_name"
        case translationsCount = "translations_count"
        case translatedName = "translated_name"
    }
}

public struct LanguagesResponse: Codable {
    public let languages: [LanguageResponse]
}

public struct TranslatedName: Codable {
    public let name: String
    public let languageName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case languageName = "language_name"
    }
}
