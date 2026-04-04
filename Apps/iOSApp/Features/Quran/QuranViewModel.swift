//
//  QuranViewModel.swift
//  Hira
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

@Observable
public class QuranViewModel: BaseViewModel {
    public var selectedBottomTab: QuranBottomTab = .surah
    public var selectedTopTab: QuranTopTab = .surah
    public var searchQuery: String = ""
    
    public var surahs: [Surah] = Surah.previewList
    public var recentSurah: Surah = Surah.preview
    
    // Progress Data
    public var surahProgress: Double = 0.45 // 45%
    public var khatamProgress: Double = 0.12 // 12%
    
    public var stories: [QuranStory] = [
        QuranStory(title: "Prophet Ibrahim's Faith", description: "The story of unwavering faith and submission to Allah", image: "story_ibrahim"),
        QuranStory(title: "The Night Journey", description: "Prophet Muhammad's miraculous journey to Jerusalem", image: "story_isra")
    ]
    
    public var topics: [QuranTopic] = [
        QuranTopic(title: "Faith & Belief", image: "topic_faith", storyCount: 12),
        QuranTopic(title: "Prayer & Worship", image: "topic_prayer", storyCount: 8),
        QuranTopic(title: "Charity & Giving", image: "topic_charity", storyCount: 6),
        QuranTopic(title: "Patience & Trust", image: "topic_patience", storyCount: 15),
        QuranTopic(title: "Family Values", image: "topic_family", storyCount: 9),
        QuranTopic(title: "Justice & Fairness", image: "topic_justice", storyCount: 11),
        QuranTopic(title: "Forgiveness", image: "topic_forgiveness", storyCount: 7),
        QuranTopic(title: "Gratitude", image: "topic_gratitude", storyCount: 10)
    ]
    
    public var juzList: [JuzProgress] = [
        JuzProgress(number: 1, surahRange: "Al-Fatihah - Al-Baqarah", progress: 0.41),
        JuzProgress(number: 2, surahRange: "Al-Baqarah", progress: 0.98),
        JuzProgress(number: 3, surahRange: "Al-Baqarah - Ali 'Imran", progress: 0.01),
        JuzProgress(number: 4, surahRange: "Ali 'Imran - An-Nisa", progress: 0.04),
        JuzProgress(number: 5, surahRange: "An-Nisa", progress: 0.42),
        JuzProgress(number: 6, surahRange: "An-Nisa - Al-Ma'idah", progress: 0.71)
    ]
    
    public var bookmarks: [QuranBookmark] = [
        QuranBookmark(surahNumber: 2, surahName: "Al-Baqarah", surahNameArabic: "البقرة", ayahNumber: 255, timeAgo: "2 days", arabicText: "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌۭ وَلَا نَوْمٌۭ"),
        QuranBookmark(surahNumber: 36, surahName: "Yasin", surahNameArabic: "يس", ayahNumber: 1, timeAgo: "1 week", arabicText: "يسٓ"),
        QuranBookmark(surahNumber: 55, surahName: "Ar-Rahman", surahNameArabic: "الرحمن", ayahNumber: 33, timeAgo: "2 weeks", arabicText: "يَٰمَعْشَرَ ٱلْجِنِّ وَٱلْإِنسِ إِنِ ٱسْتَطَعْتُمْ أَن تَنفُذُوا۟ مِنْ أَقْطَارِ ٱلسَّمَٰوَٰتِ وَٱلْأَرْضِ")
    ]
    
    public var dailyReminders: [DailyReminder] = [
        DailyReminder(title: "Morning Dhikr", description: "And it is He who sends down rain from heaven, and We produce thereby the vegetation of every kind", reference: "Al-An'am 6:99", arabicText: "وَهُوَ ٱلَّذِىٓ أَنزَلَ مِنَ ٱلسَّمَآءِ مَآءًۭ فَأَخْرَجْنَا بِهِۦ نَبَاتَ كُلِّ شَىْءٍۭ", time: "05:00 AM", likes: 123, bookmarks: 123, shares: 123, image: "morning_dhikr_bg"),
        DailyReminder(title: "Midday Reflection", description: "And whoever relies upon Allah - then He is sufficient for him. Indeed, Allah will accomplish His purpose", reference: "Al-Talaq 65:3", arabicText: "وَمَن يَتَوَكَّلْ عَلَى ٱللَّهِ فَهُوَ حَسْبُهُۥٓ ۚ إِنَّ ٱللَّهَ بَٰلِغُ أَمْرِهِۦ", time: "12:30 PM", likes: 89, bookmarks: 45, shares: 12, image: "midday_reflect_bg")
    ]
    
    public override init() {
        super.init()
    }
    
    public var filteredSurahs: [Surah] {
        if searchQuery.isEmpty {
            return surahs
        }
        return surahs.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }
}
