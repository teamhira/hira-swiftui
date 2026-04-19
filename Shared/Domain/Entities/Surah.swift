//
//  Surah.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public struct Surah: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let number: Int
    public let name: String
    public let nameArabic: String
    public let nameComplex: String
    public let nameTranslation: String
    public let versesCount: Int
    public let revelationPlace: String
    public let revelationOrder: Int?
    public let bismillahPre: Bool
    public let pages: [Int]?
    
    public init(
        id: String,
        number: Int,
        name: String,
        nameArabic: String,
        nameComplex: String,
        nameTranslation: String,
        versesCount: Int,
        revelationPlace: String,
        revelationOrder: Int? = nil,
        bismillahPre: Bool = true,
        pages: [Int]? = nil
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.nameArabic = nameArabic
        self.nameComplex = nameComplex
        self.nameTranslation = nameTranslation
        self.versesCount = versesCount
        self.revelationPlace = revelationPlace
        self.revelationOrder = revelationOrder
        self.bismillahPre = bismillahPre
        self.pages = pages
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name = "name_simple", nameArabic = "name_arabic", 
             nameComplex = "name_complex", versesCount = "verses_count", 
             revelationPlace = "revelation_place", revelationOrder = "revelation_order", 
             bismillahPre = "bismillah_pre", pages, nameTranslation = "translated_name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle ID as Int or String, and also use it for 'number'
        let surahIdInt: Int
        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
            surahIdInt = intId
        } else {
            id = try container.decode(String.self, forKey: .id)
            surahIdInt = Int(id) ?? 0
        }
        
        self.number = surahIdInt
        name = try container.decode(String.self, forKey: .name)
        nameArabic = try container.decode(String.self, forKey: .nameArabic)
        nameComplex = try container.decode(String.self, forKey: .nameComplex)
        
        // nameTranslation might be a nested object {"name": "..."}
        if let nested = try? container.decode([String: String].self, forKey: .nameTranslation) {
            nameTranslation = nested["name"] ?? ""
        } else {
            nameTranslation = try container.decode(String.self, forKey: .nameTranslation)
        }
        
        versesCount = try container.decode(Int.self, forKey: .versesCount)
        revelationPlace = try container.decode(String.self, forKey: .revelationPlace)
        revelationOrder = try? container.decode(Int.self, forKey: .revelationOrder)
        bismillahPre = try container.decode(Bool.self, forKey: .bismillahPre)
        pages = try? container.decode([Int].self, forKey: .pages)
    }
}

// MARK: - Preview
extension Surah {
    public static let preview = Surah(
        id: "1",
        number: 1,
        name: "Al-Fatihah",
        nameArabic: "الفاتحة",
        nameComplex: "Al-Fātiĥah",
        nameTranslation: "The Opening",
        versesCount: 7,
        revelationPlace: "Mecca",
        revelationOrder: 5,
        bismillahPre: false,
        pages: [1, 1]
    )
    
    public static let previewList = [
        preview,
        Surah(
            id: "2",
            number: 2,
            name: "Al-Baqarah",
            nameArabic: "البقرة",
            nameComplex: "Al-Baqarah",
            nameTranslation: "The Cow",
            versesCount: 286,
            revelationPlace: "Medina",
            revelationOrder: 87,
            bismillahPre: true,
            pages: [2, 49]
        )
    ]
}
