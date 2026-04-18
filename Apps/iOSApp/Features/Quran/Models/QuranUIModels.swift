//
//  QuranUIModels.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public enum QuranBottomTab: String, CaseIterable {
    case surah = "quran_tab_surah"
    case topic = "quran_tab_topic"
    case daily = "quran_tab_daily"
    
    public func title(language: LanguageManager) -> String { language.localizedString(self.rawValue) }
    
    public var icon: String {
        switch self {
        case .surah: return "book.fill"
        case .topic: return "list.bullet.indent"
        case .daily: return "calendar.day.timeline.left"
        }
    }
}

public struct PageItem: Identifiable, Hashable {
    public var id: Int { number }
    public let number: Int
    
    public init(number: Int) {
        self.number = number
    }
}

// Enums for Settings
public enum QuranReadingMode: String, CaseIterable, Codable {
    case list, page
}

public enum QuranScript: String, CaseIterable, Codable {
    case uthmani = "Uthmani"
    case indopak = "Indopak"
}

public enum QuranRepetition: String, CaseIterable, Codable {
    case never = "Never"
    case once = "1 Time"
    case twice = "2 Times"
    case thrice = "3 Times"
    case indefinitely = "Indefinitely"
}

public enum QuranCompletionAction: String, CaseIterable, Codable {
    case stop = "Stop Playing"
    case repeatSura = "Repeat Sura"
    case playNext = "Play Next Sura"
}

public struct QuranAyah: Identifiable, Hashable {
    public var id: String { "\(surahNumber)_\(number)" }
    public let surahNumber: Int
    public let number: Int
    public let textArabic: String
    public let textLatin: String
    public let translation: String
    public let words: [Word]
    public let audio: VerseAudio?
    public let pageNumber: Int?
    public let juzNumber: Int?
    public let isPlaceholder: Bool
    
    // Manual Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(surahNumber)
        hasher.combine(number)
    }
    
    public static func == (lhs: QuranAyah, rhs: QuranAyah) -> Bool {
        lhs.surahNumber == rhs.surahNumber && 
        lhs.number == rhs.number
    }
    
    // Initializer from domain Ayah
    public init(from ayah: Ayah) {
        self.surahNumber = ayah.chapterId ?? Int(ayah.surahId) ?? 0
        self.number = ayah.verseNumber
        self.pageNumber = ayah.pageNumber
        self.juzNumber = ayah.juzNumber
        
        // Prefer Uthmani script; fall back to word-construction if text is missing
        if let directText = ayah.text, !directText.isEmpty {
            self.textArabic = directText
        } else {
            // Construct from words text if available (common for some translations)
            self.textArabic = ayah.words?.compactMap { $0.text }.joined(separator: " ") ?? ""
        }
        
        // First word transliteration joined, or empty
        self.textLatin = ayah.words?
            .compactMap { $0.transliteration }
            .joined(separator: " ") ?? ""
            
        self.translation = ayah.translations?.first?.text ?? ""
        self.words = ayah.words ?? []
        self.audio = ayah.audio
        self.isPlaceholder = false
    }
    
    // Legacy init for preview / static data
    public init(surahNumber: Int, number: Int, textArabic: String, textLatin: String, translation: String, words: [Word] = [], audio: VerseAudio? = nil, pageNumber: Int? = nil, juzNumber: Int? = nil, isPlaceholder: Bool = false) {
        self.surahNumber = surahNumber
        self.number = number
        self.textArabic = textArabic
        self.textLatin = textLatin
        self.translation = translation
        self.words = words
        self.audio = audio
        self.pageNumber = pageNumber
        self.juzNumber = juzNumber
        self.isPlaceholder = isPlaceholder
    }
}

public enum QuranTopTab: String, CaseIterable {
    case surah = "quran_tab_surah"
    case juz = "quran_tab_juz"
    case bookmark = "quran_tab_bookmark"
    
    public func title(language: LanguageManager) -> String { language.localizedString(self.rawValue) }
}

public struct QuranStory: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let image: String
}

public struct QuranTopic: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let image: String
    public let storyCount: Int
}

public struct JuzProgress: Identifiable, Hashable {
    public let id: UUID
    public let number: Int
    public let surahRange: String
    public let progress: Double
    public let verseMapping: [String: String]
    
    public init(id: UUID = UUID(), number: Int, surahRange: String, progress: Double, verseMapping: [String: String]) {
        self.id = id
        self.number = number
        self.surahRange = surahRange
        self.progress = progress
        self.verseMapping = verseMapping
    }
    
    public var descriptionKey: String {
        "quran_juz_desc_\(number)"
    }
}

public struct QuranBookmark: Identifiable, Hashable {
    public let id = UUID()
    public let surahNumber: Int
    public let surahName: String?
    public let surahNameArabic: String?
    public let ayahNumber: Int
    public let timeAgo: String
    public let arabicText: String?
    public let apiId: String?
    
    public init(id: UUID = UUID(), surahNumber: Int, surahName: String?, surahNameArabic: String?, ayahNumber: Int, timeAgo: String, arabicText: String?, apiId: String? = nil) {
        self.surahNumber = surahNumber
        self.surahName = surahName
        self.surahNameArabic = surahNameArabic
        self.ayahNumber = ayahNumber
        self.timeAgo = timeAgo
        self.arabicText = arabicText
        self.apiId = apiId
    }
}

public struct DailyReminder: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let reference: String
    public let arabicText: String
    public let time: String
    public var likes: Int
    public var bookmarks: Int
    public var shares: Int
    public let image: String
}

public struct QuranHistoryItem: Identifiable, Hashable {
    public let id = UUID()
    public let surahNumber: Int
    public let surahName: String
    public let surahNameArabic: String
    public let ayahNumber: Int
    public let date: Date
}
