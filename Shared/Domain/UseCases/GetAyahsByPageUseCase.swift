//
//  GetAyahsByPageUseCase.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public protocol GetAyahsByPageUseCase {
    func execute(
        pageNumber: Int,
        language: String?,
        translations: [Int]?,
        words: Bool?,
        audio: Int?
    ) -> AnyPublisher<[Ayah], Error>
}

public class GetAyahsByPageUseCaseImpl: GetAyahsByPageUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    public func execute(
        pageNumber: Int,
        language: String? = nil,
        translations: [Int]? = nil,
        words: Bool? = true,
        audio: Int? = nil
    ) -> AnyPublisher<[Ayah], Error> {
        repository.getAyahsByPage(pageNumber: pageNumber, page: 1, perPage: 300, translations: translations, words: words, audio: audio)
    }
}
