//
//  GetSurahListUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class GetSurahListUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<[Surah], Error> {
        return repository.getSurahs()
    }
}
