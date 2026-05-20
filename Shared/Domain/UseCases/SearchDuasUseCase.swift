//
//  SearchDuasUseCase.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import Combine

public protocol SearchDuasUseCase {
    func execute(query: String, category: String?) -> AnyPublisher<UmmahResponse<SearchDuasResponse>, Error>
}

public class SearchDuasUseCaseImpl: SearchDuasUseCase {
    private let repository: UmmahDuaRepository
    
    public init(repository: UmmahDuaRepository) {
        self.repository = repository
    }
    
    public func execute(query: String, category: String?) -> AnyPublisher<UmmahResponse<SearchDuasResponse>, Error> {
        repository.searchDuas(query: query, category: category)
    }
}
