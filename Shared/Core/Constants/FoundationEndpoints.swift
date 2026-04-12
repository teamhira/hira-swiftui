//
//  FoundationEndpoints.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct FoundationEndpoints {
    // MARK: - OAuth
    public static let oauthToken = "oauth2/token"
    
    // MARK: - Chapters (Surah)
    public static let chapters = "chapters"
    public static func chapter(id: String) -> String { "chapters/\(id)" }
    public static func chapterInfo(id: String) -> String { "chapters/\(id)/info" }
    
    // MARK: - Verses (Ayah)
    public static func versesByChapter(id: String) -> String { "verses/by_chapter/\(id)" }
    public static func versesByKey(key: String) -> String { "verses/by_key/\(key)" }
    public static func versesByJuz(id: Int) -> String { "verses/by_juz/\(id)" }
    public static func versesByHizb(id: Int) -> String { "verses/by_hizb/\(id)" }
    public static func versesByRubElHizb(id: Int) -> String { "verses/by_rub_el_hizb/\(id)" }
    public static func versesByRuku(id: Int) -> String { "verses/by_ruku/\(id)" }
    public static func versesByManzil(id: Int) -> String { "verses/by_manzil/\(id)" }
    public static func versesByPage(id: Int) -> String { "verses/by_page/\(id)" }
    public static func versesByRange(from: Int, to: Int) -> String { "verses/by_range/\(from)-\(to)" }
    public static let randomVerse = "verses/random"
    
    // MARK: - Quran (Scripts)
    public static func quranByScript(_ script: String) -> String { "quran/verses/\(script)" }
    
    // MARK: - Audio
    public static func chapterRecitations(id: Int) -> String { "chapter_recitations/\(id)" }
    public static func chapterRecitationAudioFiles(id: Int) -> String { "chapter_recitations/\(id)" }
    public static func chapterRecitationAudioFile(id: Int, chapterId: Int) -> String { "chapter_recitations/\(id)/\(chapterId)" }
    
    public static func recitationAudioFiles(id: Int) -> String { "recitations/\(id)/audio_files" }
    public static func audioByChapter(recitationId: Int, chapterNumber: Int) -> String { "chapter_recitations/\(recitationId)/\(chapterNumber)" }
    public static func audioByAyah(recitationId: Int, verseKey: String) -> String { "recitations/\(recitationId)/by_ayah/\(verseKey)" }
    public static func audioByJuz(recitationId: Int, juzNumber: Int) -> String { "recitations/\(recitationId)/by_juz/\(juzNumber)" }
    public static func audioByPage(recitationId: Int, pageNumber: Int) -> String { "recitations/\(recitationId)/by_page/\(pageNumber)" }
    public static func audioByHizb(recitationId: Int, hizbNumber: Int) -> String { "recitations/\(recitationId)/by_hizb/\(hizbNumber)" }
    public static func audioByRubElHizb(recitationId: Int, number: Int) -> String { "recitations/\(recitationId)/by_rub_el_hizb/\(number)" }
    public static func audioByManzil(recitationId: Int, number: Int) -> String { "recitations/\(recitationId)/by_manzil/\(number)" }
    public static func audioByRuku(recitationId: Int, number: Int) -> String { "recitations/\(recitationId)/by_ruku/\(number)" }
    
    public static func audioTimestamp(reciterId: Int) -> String { "audio/reciters/\(reciterId)/timestamp" }
    public static func audioLookup(reciterId: Int) -> String { "audio/reciters/\(reciterId)/lookup" }
    
    // MARK: - Resources
    public static let languages = "resources/languages"
    public static let recitations = "resources/recitations"
    public static func recitationInfo(id: Int) -> String { "resources/recitations/\(id)" }
    public static let tafsirs = "resources/tafsirs"
    public static let translations = "resources/translations"
    
    // MARK: - Tafsirs
    public static func tafsirByChapter(tafsirId: Int, chapterNumber: Int) -> String {
        "tafsirs/\(tafsirId)/by_chapter/\(chapterNumber)"
    }
    public static func tafsirByVerse(tafsirId: Int, verseKey: String) -> String {
        "tafsirs/\(tafsirId)/by_verse/\(verseKey)"
    }
    
    // MARK: - Translations
    public static func translationByChapter(resourceId: Int, chapterNumber: Int) -> String {
        "translations/\(resourceId)/by_chapter/\(chapterNumber)"
    }
    public static func translationByVerse(resourceId: Int, verseKey: String) -> String {
        "translations/\(resourceId)/by_verse/\(verseKey)"
    }
    public static func translationByJuz(resourceId: Int, juzNumber: Int) -> String {
        "translations/\(resourceId)/by_juz/\(juzNumber)"
    }
    public static func translationByPage(resourceId: Int, pageNumber: Int) -> String {
        "translations/\(resourceId)/by_page/\(pageNumber)"
    }
    
    // MARK: - Footnote
    public static func footnote(id: Int) -> String { "footnotes/\(id)" }
    
    // MARK: - Structural Units
    public static let juzs = "juzs"
    public static func juz(id: Int) -> String { "juzs/\(id)" }
    
    public static let hizbs = "hizbs"
    public static func hizb(id: Int) -> String { "hizbs/\(id)" }
    
    public static let manzils = "manzils"
    public static func manzil(id: Int) -> String { "manzils/\(id)" }
    
    public static let rukus = "rukus"
    public static func ruku(id: Int) -> String { "rukus/\(id)" }
    
    public static let rubElHizbs = "rub_el_hizbs"
    public static func rubElHizb(id: Int) -> String { "rub_el_hizbs/\(id)" }
    
    // MARK: - Quran Reflect
    public static func quranReflectPost(id: Int) -> String { "quran-reflect/v1/posts/\(id)" }
    public static let quranReflectFeed = "quran-reflect/v1/posts/feed"
    
    // MARK: - Search
    public static let search = "search"
}
