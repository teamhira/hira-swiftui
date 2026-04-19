//
//  StructuralUnitsResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

// MARK: - Juz
public struct JuzsListResponse: Codable {
    public let juzs: [JuzResponse]
}

public struct SingleJuzResponse: Codable {
    public let juz: JuzResponse
}

public struct JuzResponse: Codable {
    public let id: Int
    public let juzNumber: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case juzNumber = "juz_number"
        case verseMapping = "verse_mapping"
        case firstVerseId = "first_verse_id"
        case lastVerseId = "last_verse_id"
        case versesCount = "verses_count"
    }
}

// MARK: - Hizb
public struct HizbsListResponse: Codable {
    public let hizbs: [HizbResponse]
}

public struct SingleHizbResponse: Codable {
    public let hizb: HizbResponse
}

public struct HizbResponse: Codable {
    public let id: Int
    public let hizbNumber: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case hizbNumber = "hizb_number"
        case verseMapping = "verse_mapping"
        case firstVerseId = "first_verse_id"
        case lastVerseId = "last_verse_id"
        case versesCount = "verses_count"
    }
}

// MARK: - Rub El Hizb
public struct RubElHizbsListResponse: Codable {
    public let rubElHizbs: [RubElHizbResponse]
    
    enum CodingKeys: String, CodingKey {
        case rubElHizbs = "rub_el_hizbs"
    }
}

public struct SingleRubElHizbResponse: Codable {
    public let rubElHizb: RubElHizbResponse
    
    enum CodingKeys: String, CodingKey {
        case rubElHizb = "rub_el_hizb"
    }
}

public struct RubElHizbResponse: Codable {
    public let id: Int
    public let rubElHizbNumber: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case rubElHizbNumber = "rub_el_hizb_number"
        case verseMapping = "verse_mapping"
        case firstVerseId = "first_verse_id"
        case lastVerseId = "last_verse_id"
        case versesCount = "verses_count"
    }
}

// MARK: - Manzil
public struct ManzilsListResponse: Codable {
    public let manzils: [ManzilResponse]
}

public struct SingleManzilResponse: Codable {
    public let manzil: ManzilResponse
}

public struct ManzilResponse: Codable {
    public let id: Int
    public let manzilNumber: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case manzilNumber = "manzil_number"
        case verseMapping = "verse_mapping"
        case firstVerseId = "first_verse_id"
        case lastVerseId = "last_verse_id"
        case versesCount = "verses_count"
    }
}

// MARK: - Ruku
public struct RukusListResponse: Codable {
    public let rukus: [RukuResponse]
}

public struct SingleRukuResponse: Codable {
    public let ruku: RukuResponse
}

public struct RukuResponse: Codable {
    public let id: Int
    public let rukuNumber: Int
    public let verseMapping: [String: String]
    public let firstVerseId: Int
    public let lastVerseId: Int
    public let versesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case rukuNumber = "ruku_number"
        case verseMapping = "verse_mapping"
        case firstVerseId = "first_verse_id"
        case lastVerseId = "last_verse_id"
        case versesCount = "verses_count"
    }
}
