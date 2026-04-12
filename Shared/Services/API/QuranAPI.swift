//
//  QuranAPI.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class QuranAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    // MARK: - Chapters
    
    public func getChapters(language: String) -> AnyPublisher<SurasResponse, Error> {
        let queryItems = [URLQueryItem(name: "language", value: language)]
        return client.request(FoundationEndpoints.chapters, method: .get, queryItems: queryItems)
    }
    
    public func getChapter(id: String) -> AnyPublisher<SingleSurahResponse, Error> {
        return client.request(FoundationEndpoints.chapter(id: id), method: .get)
    }
    
    public func getChapterInfo(id: String, language: String?) -> AnyPublisher<SurahInfoResponse, Error> {
        var query: [URLQueryItem]?
        if let lang = language { query = [URLQueryItem(name: "language", value: lang)] }
        return client.request(FoundationEndpoints.chapterInfo(id: id), method: .get, queryItems: query)
    }
    
    // MARK: - Verses
    
    public func getVersesByChapter(id: String, language: String, page: Int, perPage: Int, translations: [Int], words: Bool, audio: Int? = nil) -> AnyPublisher<AyahsResponse, Error> {
        let query = ayahByChapterQueryItems(language: language, page: page, perPage: perPage, translations: translations, words: words, audio: audio)
        return client.request(FoundationEndpoints.versesByChapter(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByJuz(id: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<AyahsResponse, Error> {
        let query = queryItems(page: page, perPage: perPage, translations: translations, words: words)
        return client.request(FoundationEndpoints.versesByJuz(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByPage(id: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?, audio: Int? = nil) -> AnyPublisher<AyahsResponse, Error> {
        let query = ayahByChapterQueryItems(language: "en", page: 1, perPage: 300, translations: translations ?? [], words: words ?? true, audio: audio)
        return client.request(FoundationEndpoints.versesByPage(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByHizb(id: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<AyahsResponse, Error> {
        let query = queryItems(page: page, perPage: perPage, translations: translations, words: words)
        return client.request(FoundationEndpoints.versesByHizb(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByRubElHizb(id: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<AyahsResponse, Error> {
        let query = queryItems(page: page, perPage: perPage, translations: translations, words: words)
        return client.request(FoundationEndpoints.versesByRubElHizb(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByManzil(id: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<AyahsResponse, Error> {
        let query = queryItems(page: page, perPage: perPage, translations: translations, words: words)
        return client.request(FoundationEndpoints.versesByManzil(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByRuku(id: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<AyahsResponse, Error> {
        let query = queryItems(page: page, perPage: perPage, translations: translations, words: words)
        return client.request(FoundationEndpoints.versesByRuku(id: id), method: .get, queryItems: query)
    }
    
    public func getVersesByRange(range: String, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<AyahsResponse, Error> {
        let query = queryItems(page: page, perPage: perPage, translations: translations, words: words)
        return client.request("verses/by_range/\(range)", method: .get, queryItems: query)
    }
    
    public func getVerseByKey(key: String, translations: [Int]?, words: Bool?) -> AnyPublisher<SingleAyahResponse, Error> {
        var query: [URLQueryItem]?
        if let trans = translations { query = [URLQueryItem(name: "translations", value: trans.map(String.init).joined(separator: ","))] }
        if let words = words {
            if query == nil { query = [] }
            query?.append(URLQueryItem(name: "words", value: String(words)))
        }
        return client.request(FoundationEndpoints.versesByKey(key: key), method: .get, queryItems: query)
    }
    
    public func getRandomVerse(translations: [Int]?, words: Bool?) -> AnyPublisher<SingleAyahResponse, Error> {
        var query: [URLQueryItem]?
        if let trans = translations { query = [URLQueryItem(name: "translations", value: trans.map(String.init).joined(separator: ","))] }
        if let words = words {
            if query == nil { query = [] }
            query?.append(URLQueryItem(name: "words", value: String(words)))
        }
        return client.request(FoundationEndpoints.randomVerse, method: .get, queryItems: query)
    }
    
    public func getQuranByScript(script: String, chapterNumber: Int?) -> AnyPublisher<AyahsResponse, Error> {
        var queryItems: [URLQueryItem]?
        if let chapter = chapterNumber { queryItems = [URLQueryItem(name: "chapter_number", value: String(chapter))] }
        return client.request(FoundationEndpoints.quranByScript(script), method: .get, queryItems: queryItems)
    }
    
    // MARK: - Tafsir & Translation
    
    public func getTafsirsByChapter(tafsirId: Int, chapterNumber: Int) -> AnyPublisher<TafsirsResponse, Error> {
        return client.request(FoundationEndpoints.tafsirByChapter(tafsirId: tafsirId, chapterNumber: chapterNumber), method: .get)
    }
    
    public func getTafsirByVerse(tafsirId: Int, verseKey: String) -> AnyPublisher<SingleTafsirResponse, Error> {
        return client.request(FoundationEndpoints.tafsirByVerse(tafsirId: tafsirId, verseKey: verseKey), method: .get)
    }
    
    public func getTranslationsByChapter(resourceId: Int, chapterNumber: Int) -> AnyPublisher<TranslationsResponse, Error> {
        return client.request(FoundationEndpoints.translationByChapter(resourceId: resourceId, chapterNumber: chapterNumber), method: .get)
    }
    
    public func getTranslationByVerse(resourceId: Int, verseKey: String) -> AnyPublisher<TranslationsResponse, Error> {
        return client.request(FoundationEndpoints.translationByVerse(resourceId: resourceId, verseKey: verseKey), method: .get)
    }
    
    public func getTranslationsByJuz(resourceId: Int, juzNumber: Int) -> AnyPublisher<TranslationsResponse, Error> {
        return client.request(FoundationEndpoints.translationByJuz(resourceId: resourceId, juzNumber: juzNumber), method: .get)
    }
    
    public func getTranslationsByPage(resourceId: Int, pageNumber: Int) -> AnyPublisher<TranslationsResponse, Error> {
        return client.request(FoundationEndpoints.translationByPage(resourceId: resourceId, pageNumber: pageNumber), method: .get)
    }
    
    // MARK: - Structural Units
    
    public func getJuzs() -> AnyPublisher<JuzsListResponse, Error> {
        return client.request(FoundationEndpoints.juzs, method: .get)
    }
    
    public func getJuz(id: Int) -> AnyPublisher<SingleJuzResponse, Error> {
        return client.request(FoundationEndpoints.juz(id: id), method: .get)
    }
    
    public func getHizbs() -> AnyPublisher<HizbsListResponse, Error> {
        return client.request(FoundationEndpoints.hizbs, method: .get)
    }
    
    public func getHizb(id: Int) -> AnyPublisher<SingleHizbResponse, Error> {
        return client.request(FoundationEndpoints.hizb(id: id), method: .get)
    }
    
    public func getManzils() -> AnyPublisher<ManzilsListResponse, Error> {
        return client.request(FoundationEndpoints.manzils, method: .get)
    }
    
    public func getManzil(id: Int) -> AnyPublisher<SingleManzilResponse, Error> {
        return client.request(FoundationEndpoints.manzil(id: id), method: .get)
    }
    
    public func getRukus() -> AnyPublisher<RukusListResponse, Error> {
        return client.request(FoundationEndpoints.rukus, method: .get)
    }
    
    public func getRuku(id: Int) -> AnyPublisher<SingleRukuResponse, Error> {
        return client.request(FoundationEndpoints.ruku(id: id), method: .get)
    }
    
    public func getRubElHizbs() -> AnyPublisher<RubElHizbsListResponse, Error> {
        return client.request(FoundationEndpoints.rubElHizbs, method: .get)
    }
    
    public func getRubElHizb(id: Int) -> AnyPublisher<SingleRubElHizbResponse, Error> {
        return client.request(FoundationEndpoints.rubElHizb(id: id), method: .get)
    }
    
    public func getFootnote(id: Int) -> AnyPublisher<FootnoteResponse, Error> {
        return client.request(FoundationEndpoints.footnote(id: id), method: .get)
    }
    
    // MARK: - Helpers
    
    private func queryItems(page: Int, perPage: Int, translations: [Int]?, words: Bool?, audio: Int? = nil) -> [URLQueryItem] {
        var items = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "fields", value: "text_uthmani,text_indopak,verse_key,verse_number,chapter_id,audio"),
            URLQueryItem(name: "word_fields", value: "text_uthmani_tajweed,text_indopak,translation,transliteration,audio_url,code_v2,chapter_id"),
            URLQueryItem(name: "translation_fields", value: "resource_name,language_name,text")
        ]
        if let trans = translations, !trans.isEmpty { items.append(URLQueryItem(name: "translations", value: trans.map(String.init).joined(separator: ","))) }
        if let words = words { items.append(URLQueryItem(name: "words", value: String(words))) }
        if let audio = audio { items.append(URLQueryItem(name: "audio", value: String(audio))) }
        return items
    }
    
    private func ayahByChapterQueryItems(language: String, page: Int, perPage: Int, translations: [Int], words: Bool, audio: Int? = nil) -> [URLQueryItem] {
        var items = [
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "fields", value: "text_uthmani,text_indopak,verse_key,verse_number,chapter_id,audio"),
            URLQueryItem(name: "word_fields", value: "text_uthmani_tajweed,text_indopak,translation,transliteration,audio_url,code_v2,chapter_id"),
            URLQueryItem(name: "translation_fields", value: "resource_name,language_name,text"),
            URLQueryItem(name: "words", value: String(words))
        ]
        
        if !translations.isEmpty {
            items.append(URLQueryItem(name: "translations", value: translations.map(String.init).joined(separator: ",")))
        }
        
        if let audioId = audio {
            items.append(URLQueryItem(name: "audio", value: String(audioId)))
        }
        
        return items
    }
}
