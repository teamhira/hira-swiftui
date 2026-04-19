//
//  SurahResponse.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct SurasResponse: Codable {
    public let chapters: [SurahResponse]
}

public struct SingleSurahResponse: Codable {
    public let chapter: SurahResponse
}

public struct SurahResponse: Codable {
    public let id: Int
    public let revelationPlace: String
    public let revelationOrder: Int
    public let bismillahPre: Bool
    public let nameSimple: String
    public let nameComplex: String
    public let nameArabic: String
    public let versesCount: Int
    public let pages: [Int]
    public let translatedName: TranslatedName
    
    enum CodingKeys: String, CodingKey {
        case id
        case revelationPlace = "revelation_place"
        case revelationOrder = "revelation_order"
        case bismillahPre = "bismillah_pre"
        case nameSimple = "name_simple"
        case nameComplex = "name_complex"
        case nameArabic = "name_arabic"
        case versesCount = "verses_count"
        case pages
        case translatedName = "translated_name"
    }
    
    public struct TranslatedName: Codable {
        public let languageName: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case languageName = "language_name"
            case name
        }
    }
    
    func toDomain() -> Surah {
        return Surah(
            id: String(id),
            number: id,
            name: nameSimple,
            nameArabic: nameArabic,
            nameComplex: nameComplex,
            nameTranslation: translatedName.name,
            versesCount: versesCount,
            revelationPlace: revelationPlace.capitalized,
            revelationOrder: revelationOrder,
            bismillahPre: bismillahPre,
            pages: pages
        )
    }
}
