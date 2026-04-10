//
//  QuranViewModel.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation

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
    public let id = UUID()
    public let number: Int
    public let surahRange: String
    public let progress: Double
}

public struct QuranBookmark: Identifiable, Hashable {
    public let id = UUID()
    public let surahNumber: Int
    public let surahName: String
    public let surahNameArabic: String
    public let ayahNumber: Int
    public let timeAgo: String
    public let arabicText: String
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

@Observable
public class QuranViewModel: BaseViewModel {
    public var selectedBottomTab: QuranBottomTab = .surah
    public var selectedTopTab: QuranTopTab = .surah
    public var searchQuery: String = ""
    public var showingHistory: Bool = false
    
    public var surahs: [Surah] = [] // Initial empty, will be populated
    public var recentSurah: Surah?
    
    // Settings State
    public var theme: String = "System"
    public var textSize: CGFloat = 18
    public var readingMode: QuranReadingMode = .list
    public var keepScreenOn: Bool = false
    
    public var script: QuranScript = .uthmani
    public var showTajweed: Bool = true
    
    public var showTranslation: Bool = true
    public var selectedTranslation: String = "English: Abdullah Yusuf Ali"
    
    public var showTransliteration: Bool = true
    public var selectedTransliteration: String = "English"
    
    public var audioEnabled: Bool = true
    public var selectedReciter: String = "Mishary Rashid Alafasy"
    public var autoScroll: Bool = true
    public var repetition: QuranRepetition = .never
    public var completionAction: QuranCompletionAction = .stop
    
    // UI State for Detail
    public var activeAyah: QuranAyah?
    public var selectedAyah: QuranAyah?
    public var showingAyahOptions: Bool = false
    public var showingSettings: Bool = false
    public var showingInfo: Bool = false
    
    // Mock Progress Data
    public var surahProgress: Double = 0.45
    public var khatamProgress: Double = 0.12
    
    // Other Mock Data (Stories, Topics, etc.)
    public var stories: [QuranStory] = [
        QuranStory(title: "Prophet Ibrahim's Faith", description: "The story of unwavering faith and submission to Allah", image: "story_ibrahim"),
        QuranStory(title: "The Night Journey", description: "Prophet Muhammad's miraculous journey to Jerusalem", image: "story_isra")
    ]
    
    public var topics: [QuranTopic] = [
        QuranTopic(title: "Faith & Belief", image: "topic_faith", storyCount: 12),
        QuranTopic(title: "Prayer & Worship", image: "topic_prayer", storyCount: 8),
        QuranTopic(title: "Charity & Giving", image: "topic_charity", storyCount: 6)
    ]
    
    public var juzList: [JuzProgress] = [
        JuzProgress(number: 1, surahRange: "Al-Fatihah - Al-Baqarah", progress: 0.41),
        JuzProgress(number: 2, surahRange: "Al-Baqarah", progress: 0.98),
        JuzProgress(number: 3, surahRange: "Al-Baqarah - Ali 'Imran", progress: 0.01)
    ]
    
    public var bookmarks: [QuranBookmark] = [
        QuranBookmark(surahNumber: 2, surahName: "Al-Baqarah", surahNameArabic: "البقرة", ayahNumber: 255, timeAgo: "2 days", arabicText: "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌۭ وَلَا نَوْمٌۭ")
    ]
    
    public var history: [QuranHistoryItem] = [
        QuranHistoryItem(surahNumber: 1, surahName: "Al-Fatihah", surahNameArabic: "الفاتحة", ayahNumber: 1, date: Date()),
        QuranHistoryItem(surahNumber: 2, surahName: "Al-Baqarah", surahNameArabic: "البقرة", ayahNumber: 285, date: Date()),
        QuranHistoryItem(surahNumber: 18, surahName: "Al-Kahf", surahNameArabic: "الكهف", ayahNumber: 10, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
    ]
    
    public var dailyReminders: [DailyReminder] = [
        DailyReminder(title: "Morning Dhikr", description: "And it is He who sends down rain from heaven, and We produce thereby the vegetation of every kind", reference: "Al-An'am 6:99", arabicText: "وَهُوَ ٱلَّذِىٓ أَنzَلَ مِنَ ٱلسَّمَآءِ مَآءًۭ فَأَخْرَجْنَا بِهِۦ نَبَاتَ كُلِّ شَىْءٍۭ", time: "05:00 AM", likes: 123, bookmarks: 123, shares: 123, image: "morning_dhikr_bg")
    ]
    
    public func ayahs(for surah: Surah) -> [QuranAyah] {
        // Mock ayahs for any surah with stable IDs
        [
            QuranAyah(surahNumber: surah.number, number: 1, textArabic: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", textLatin: "Bismillahir Rahmanir Rahim", translation: "In the name of Allah, the Most Gracious, the Most Merciful"),
            QuranAyah(surahNumber: surah.number, number: 2, textArabic: "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ", textLatin: "Alhamdu lillahi rabbil 'alamin", translation: "All praise is due to Allah, Lord of the worlds"),
            QuranAyah(surahNumber: surah.number, number: 3, textArabic: "ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", textLatin: "Ar-rahmani-r-rahim", translation: "The Most Gracious, the Most Merciful"),
            QuranAyah(surahNumber: surah.number, number: 4, textArabic: "مَٰلِكِ يَوْمِ ٱلدِّينِ", textLatin: "Maliki yawmi-d-din", translation: "Master of the Day of Judgment")
        ]
    }
    
    public override init() {
        super.init()
        self.surahs = [
            Surah(id: "1", number: 1, name: "Al-Fatihah", nameArabic: "الفاتحة", nameTranslation: "The Opening", versesCount: 7, revelationPlace: "Makkah"),
            Surah(id: "2", number: 2, name: "Al-Baqarah", nameArabic: "البقرة", nameTranslation: "The Cow", versesCount: 286, revelationPlace: "Madinah"),
            Surah(id: "3", number: 3, name: "Ali 'Imran", nameArabic: "آل عمران", nameTranslation: "Family of Imran", versesCount: 200, revelationPlace: "Madinah")
        ]
        self.recentSurah = surahs[0]
    }
    
    public var filteredSurahs: [Surah] {
        if searchQuery.isEmpty {
            return surahs
        }
        return surahs.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }
}
