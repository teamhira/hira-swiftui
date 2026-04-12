//
//  QuranRepository.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public protocol QuranRepository {
    // Chapters (Surah)
    func getSurahs(language: String?) -> AnyPublisher<[Surah], Error>
    func getSurahInfo(id: String) -> AnyPublisher<Surah, Error>
    func getChapterInfo(id: String, language: String?) -> AnyPublisher<SurahInfo, Error>
    
    // Verses (Ayah)
    func getAyahsByChapter(id: String, language: String?, page: Int, perPage: Int, translations: [Int]?, words: Bool?, audio: Int?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByJuz(juzNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByPage(pageNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?, audio: Int?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByHizb(hizbNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByRubElHizb(rubElHizbNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByManzil(manzilNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByRuku(rukuNumber: Int, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error>
    func getAyahsByRange(range: String, page: Int, perPage: Int, translations: [Int]?, words: Bool?) -> AnyPublisher<[Ayah], Error>
    func getAyahByKey(key: String, translations: [Int]?, words: Bool?) -> AnyPublisher<Ayah, Error>
    func getRandomAyah(translations: [Int]?, words: Bool?) -> AnyPublisher<Ayah, Error>
    
    // Quran Scripts
    func getQuranByScript(script: QuranScriptType, chapterNumber: Int?) -> AnyPublisher<[AyahResponse], Error>
    
    // Tafsir & Translation
    func getTafsirsByChapter(tafsirId: Int, chapterNumber: Int) -> AnyPublisher<[TafsirDataResponse], Error>
    func getTafsirByVerse(tafsirId: Int, verseKey: String) -> AnyPublisher<TafsirDataResponse, Error>
    func getTranslationsByChapter(resourceId: Int, chapterNumber: Int) -> AnyPublisher<[TranslationDataResponse], Error>
    func getTranslationsByVerse(resourceId: Int, verseKey: String) -> AnyPublisher<TranslationDataResponse, Error>
    func getTranslationsByJuz(resourceId: Int, juzNumber: Int) -> AnyPublisher<[TranslationDataResponse], Error>
    func getTranslationsByPage(resourceId: Int, pageNumber: Int) -> AnyPublisher<[TranslationDataResponse], Error>
    
    // Structural Metadata
    func getJuzs() -> AnyPublisher<[JuzResponse], Error>
    func getJuzInfo(id: Int) -> AnyPublisher<JuzResponse, Error>
    func getHizbs() -> AnyPublisher<[HizbResponse], Error>
    func getHizbInfo(id: Int) -> AnyPublisher<HizbResponse, Error>
    func getManzils() -> AnyPublisher<[ManzilResponse], Error>
    func getManzilInfo(id: Int) -> AnyPublisher<ManzilResponse, Error>
    func getRukus() -> AnyPublisher<[RukuResponse], Error>
    func getRukuInfo(id: Int) -> AnyPublisher<RukuResponse, Error>
    func getRubElHizbs() -> AnyPublisher<[RubElHizbResponse], Error>
    func getRubElHizbInfo(id: Int) -> AnyPublisher<RubElHizbResponse, Error>
    
    // Footnote
    func getFootnote(id: Int) -> AnyPublisher<FootnoteResponse, Error>
}
