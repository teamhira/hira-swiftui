//
//  GetSurahInfoUseCase.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Combine
import Foundation

public protocol GetSurahInfoUseCase {
    func execute(id: String, language: String?) -> AnyPublisher<SurahInfo, Error>
}

public extension GetSurahInfoUseCase {
    func execute(id: String, language: String? = nil) -> AnyPublisher<SurahInfo, Error> {
        execute(id: id, language: language)
    }
}

public class GetSurahInfoUseCaseImpl: GetSurahInfoUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    public func execute(id: String, language: String?) -> AnyPublisher<SurahInfo, Error> {
        return repository.getChapterInfo(id: id, language: language)
    }
}
