//
//  GetSurahListUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public protocol GetSurahListUseCase {
    func execute(language: String?) -> AnyPublisher<[Surah], Error>
}

public extension GetSurahListUseCase {
    func execute(language: String? = nil) -> AnyPublisher<[Surah], Error> {
        execute(language: language)
    }
}

public class GetSurahListUseCaseImpl: GetSurahListUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    public func execute(language: String? = nil) -> AnyPublisher<[Surah], Error> {
        return repository.getSurahs(language: language)
    }
}
