//
//  GetAyahsByChapterUseCase.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol GetAyahsByChapterUseCase {
    func execute(
        chapterId: String,
        language: String?,
        page: Int,
        perPage: Int,
        translations: [Int]?,
        words: Bool,
        audio: Int?
    ) -> AnyPublisher<[Ayah], Error>
}

public extension GetAyahsByChapterUseCase {
    func execute(
        chapterId: String,
        language: String? = nil,
        page: Int = 1,
        perPage: Int = 50,
        translations: [Int]? = nil,
        words: Bool = true,
        audio: Int? = nil
    ) -> AnyPublisher<[Ayah], Error> {
        execute(
            chapterId: chapterId,
            language: language,
            page: page,
            perPage: perPage,
            translations: translations,
            words: words,
            audio: audio
        )
    }
}

public class GetAyahsByChapterUseCaseImpl: GetAyahsByChapterUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    /// Fetches a page of ayahs for a given chapter.
    /// - Parameters:
    ///   - chapterId: The surah number as a string, e.g. "1"
    ///   - language: The display language code, e.g. "en", "id", "ar"
    ///   - page: Page number (1-indexed) for pagination
    ///   - perPage: Number of ayahs per page
    ///   - translations: Optional override for translation resource IDs
    ///   - words: Whether to include word-by-word breakdown
    public func execute(
        chapterId: String,
        language: String? = nil,
        page: Int = 1,
        perPage: Int = 50,
        translations: [Int]? = nil,
        words: Bool = true,
        audio: Int? = nil
    ) -> AnyPublisher<[Ayah], Error> {
        repository.getAyahsByChapter(
            id: chapterId,
            language: language,
            page: page,
            perPage: perPage,
            translations: translations,
            words: words,
            audio: audio
        )
    }
}
