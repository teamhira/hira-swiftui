//
//  QuranRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class QuranRepositoryImpl: QuranRepository {
    private let api: QuranAPI
    private let storage: QuranStorage
    private let database: DatabaseService
    
    public init(api: QuranAPI, storage: QuranStorage, database: DatabaseService) {
        self.api = api
        self.storage = storage
        self.database = database
    }
    
    public func getSurahs(language: String?) -> AnyPublisher<[Surah], Error> {
        let lang = language ?? "en"
        
        if let cachedSurahs = storage.fetchSurahs(language: lang) {
            return Just(cachedSurahs)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return api.getChapters(language: lang)
            .map { [storage] (res: SurasResponse) in
                let surahs = res.chapters.map { $0.toDomain() }
                storage.saveSurahs(surahs, language: lang)
                return surahs
            }
            .eraseToAnyPublisher()
    }
    
    public func getSurahInfo(id: String) -> AnyPublisher<Surah, Error> {
        return api.getChapter(id: id)
            .map { (res: SingleSurahResponse) in res.chapter.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getChapterInfo(id: String, language: String?) -> AnyPublisher<SurahInfo, Error> {
        return api.getChapterInfo(id: id, language: language)
            .map { (res: SurahInfoResponse) in 
                res.chapterInfo?.toDomain() ?? SurahInfo(chapterId: Int(id) ?? 0, languageName: language ?? "en") 
            }
            .eraseToAnyPublisher()
    }
    
    public func getAyahsByChapter(
        id: String,
        language: String?,
        page: Int,
        perPage: Int,
        translations: [Int]?,
        words: Bool?,
        audio: Int? = nil
    ) -> AnyPublisher<[Ayah], Error> {
        let lang = language ?? "en"
        let translationIds = translations ?? Self.defaultTranslations(for: lang)
        let fetchWords = words ?? true
        
        if let cached = database.fetchAyahs(chapterId: id, language: lang, translationIds: translationIds) {
            // Ensure words and tajweed are present if requested
            let needsWords = words ?? true
            let hasWords = cached.first?.words != nil && !(cached.first?.words?.isEmpty ?? true)
            let hasTajweed = cached.contains(where: { $0.words?.contains(where: { !($0.textTajweed ?? "").isEmpty }) ?? false })
            
            // Critical check: If audio is requested but not in cache, force re-fetch
            let needsAudio = audio != nil
            let hasAudio = cached.first?.audio != nil
            
            if (!needsWords || (hasWords && hasTajweed)) && (!needsAudio || hasAudio) {
                return Just(cached)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
        
        return api.getVersesByChapter(id: id, language: lang, page: page, perPage: perPage, translations: translationIds, words: fetchWords, audio: audio)
            .map { [database] (res: AyahsResponse) -> [Ayah] in
                let ayahs = res.verses.map { $0.toDomain(surahId: id) }
                database.saveAyahs(ayahs, chapterId: id, language: lang, translationIds: translationIds)
                return ayahs
            }
            .eraseToAnyPublisher()
    }
    
    private static func defaultTranslations(for language: String) -> [Int] {
        switch language {
        case "id": return [33]
        case "ms": return [39]
        case "ar": return [16]
        default:   return [85]
        }
    }
    
    public func getAyahsByJuz(juzNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByJuz(id: juzNumber, page: page, perPage: perPage, translations: translations, words: words)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahsByPage(pageNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?, audio: Int? = nil) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByPage(id: pageNumber, page: page, perPage: perPage, translations: translations, words: words, audio: audio)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahsByHizb(hizbNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByHizb(id: hizbNumber, page: page, perPage: perPage, translations: translations, words: words)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahsByRubElHizb(rubElHizbNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByRubElHizb(id: rubElHizbNumber, page: page, perPage: perPage, translations: translations, words: words)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahsByManzil(manzilNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByManzil(id: manzilNumber, page: page, perPage: perPage, translations: translations, words: words)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahsByRuku(rukuNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByRuku(id: rukuNumber, page: page, perPage: perPage, translations: translations, words: words)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahsByRange(range: String, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error> {
        return api.getVersesByRange(range: range, page: page, perPage: perPage, translations: translations, words: words)
            .map { (res: AyahsResponse) in res.verses.map { $0.toDomain(surahId: "") } }.eraseToAnyPublisher()
    }
    
    public func getAyahByKey(key: String, translations: [Int]?, words: Bool?) -> AnyPublisher<Ayah, Error> {
        return api.getVerseByKey(key: key, translations: translations, words: words)
            .map { (res: SingleAyahResponse) in res.verse.toDomain(surahId: String(key.split(separator: ":").first ?? "")) }.eraseToAnyPublisher()
    }
    
    public func getRandomAyah(translations: [Int]?, words: Bool?) -> AnyPublisher<Ayah, Error> {
        return api.getRandomVerse(translations: translations, words: words)
            .map { (res: SingleAyahResponse) in res.verse.toDomain(surahId: "") }.eraseToAnyPublisher()
    }
    
    public func getQuranByScript(script: QuranScriptType, chapterNumber: Int?) -> AnyPublisher<[AyahResponse], Error> {
        return api.getQuranByScript(script: script.rawValue, chapterNumber: chapterNumber)
            .map { (res: AyahsResponse) in res.verses }.eraseToAnyPublisher()
    }
    
    public func getTafsirsByChapter(tafsirId: Int, chapterNumber: Int) -> AnyPublisher<[TafsirDataResponse], Error> {
        return api.getTafsirsByChapter(tafsirId: tafsirId, chapterNumber: chapterNumber)
            .map { (res: TafsirsResponse) in res.tafsirs }.eraseToAnyPublisher()
    }
    
    public func getTafsirByVerse(tafsirId: Int, verseKey: String) -> AnyPublisher<TafsirDataResponse, Error> {
        return api.getTafsirByVerse(tafsirId: tafsirId, verseKey: verseKey)
            .map { (res: SingleTafsirResponse) in res.tafsir }.eraseToAnyPublisher()
    }
    
    public func getTranslationsByChapter(resourceId: Int, chapterNumber: Int) -> AnyPublisher<[TranslationDataResponse], Error> {
        return api.getTranslationsByChapter(resourceId: resourceId, chapterNumber: chapterNumber)
            .map { (res: TranslationsResponse) in res.translations }.eraseToAnyPublisher()
    }
    
    public func getTranslationsByVerse(resourceId: Int, verseKey: String) -> AnyPublisher<TranslationDataResponse, Error> {
        return api.getTranslationByVerse(resourceId: resourceId, verseKey: verseKey)
            .map { (res: TranslationsResponse) in res.translations.first! }.eraseToAnyPublisher()
    }
    
    public func getTranslationsByJuz(resourceId: Int, juzNumber: Int) -> AnyPublisher<[TranslationDataResponse], Error> {
        return api.getTranslationsByJuz(resourceId: resourceId, juzNumber: juzNumber)
            .map { (res: TranslationsResponse) in res.translations }.eraseToAnyPublisher()
    }
    
    public func getTranslationsByPage(resourceId: Int, pageNumber: Int) -> AnyPublisher<[TranslationDataResponse], Error> {
        return api.getTranslationsByPage(resourceId: resourceId, pageNumber: pageNumber)
            .map { (res: TranslationsResponse) in res.translations }.eraseToAnyPublisher()
    }
    
    public func getJuzs() -> AnyPublisher<[JuzResponse], Error> {
        if let cached = database.fetchJuzs() {
            return Just(cached).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return api.getJuzs().map { [weak self] (res: JuzsListResponse) in
            self?.database.saveJuzs(res.juzs)
            return res.juzs
        }.eraseToAnyPublisher()
    }
    
    public func getJuzInfo(id: Int) -> AnyPublisher<JuzResponse, Error> {
        return api.getJuz(id: id).map { (res: SingleJuzResponse) in res.juz }.eraseToAnyPublisher()
    }
    
    public func getHizbs() -> AnyPublisher<[HizbResponse], Error> {
        return api.getHizbs().map { (res: HizbsListResponse) in res.hizbs }.eraseToAnyPublisher()
    }
    
    public func getHizbInfo(id: Int) -> AnyPublisher<HizbResponse, Error> {
        return api.getHizb(id: id).map { (res: SingleHizbResponse) in res.hizb }.eraseToAnyPublisher()
    }
    
    public func getManzils() -> AnyPublisher<[ManzilResponse], Error> {
        return api.getManzils().map { (res: ManzilsListResponse) in res.manzils }.eraseToAnyPublisher()
    }
    
    public func getManzilInfo(id: Int) -> AnyPublisher<ManzilResponse, Error> {
        return api.getManzil(id: id).map { (res: SingleManzilResponse) in res.manzil }.eraseToAnyPublisher()
    }
    
    public func getRukus() -> AnyPublisher<[RukuResponse], Error> {
        return api.getRukus().map { (res: RukusListResponse) in res.rukus }.eraseToAnyPublisher()
    }
    
    public func getRukuInfo(id: Int) -> AnyPublisher<RukuResponse, Error> {
        return api.getRuku(id: id).map { (res: SingleRukuResponse) in res.ruku }.eraseToAnyPublisher()
    }
    
    public func getRubElHizbs() -> AnyPublisher<[RubElHizbResponse], Error> {
        return api.getRubElHizbs().map { (res: RubElHizbsListResponse) in res.rubElHizbs }.eraseToAnyPublisher()
    }
    
    public func getRubElHizbInfo(id: Int) -> AnyPublisher<RubElHizbResponse, Error> {
        return api.getRubElHizb(id: id).map { (res: SingleRubElHizbResponse) in res.rubElHizb }.eraseToAnyPublisher()
    }
    
    public func getFootnote(id: Int) -> AnyPublisher<FootnoteResponse, Error> {
        return api.getFootnote(id: id)
    }
}
