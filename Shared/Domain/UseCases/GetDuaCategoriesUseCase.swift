//
//  GetDuaCategoriesUseCase.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import Combine

public protocol GetDuaCategoriesUseCase {
    func execute() -> AnyPublisher<UmmahResponse<DuaCategoriesResponse>, Error>
}

public class GetDuaCategoriesUseCaseImpl: GetDuaCategoriesUseCase {
    private let repository: UmmahDuaRepository
    
    public init(repository: UmmahDuaRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<UmmahResponse<DuaCategoriesResponse>, Error> {
        repository.getCategories()
    }
}
