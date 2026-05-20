//
//  GetDuasByCategoryUseCase.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import Combine

public protocol GetDuasByCategoryUseCase {
    func execute(id: String) -> AnyPublisher<UmmahResponse<DuasByCategoryResponse>, Error>
}

public class GetDuasByCategoryUseCaseImpl: GetDuasByCategoryUseCase {
    private let repository: UmmahDuaRepository
    
    public init(repository: UmmahDuaRepository) {
        self.repository = repository
    }
    
    public func execute(id: String) -> AnyPublisher<UmmahResponse<DuasByCategoryResponse>, Error> {
        repository.getDuasByCategory(id: id)
    }
}
