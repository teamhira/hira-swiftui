//
//  GetRandomDuaUseCase.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol GetRandomDuaUseCase {
    func execute() -> AnyPublisher<UmmahResponse<RandomDuaResponse>, Error>
}

public class GetRandomDuaUseCaseImpl: GetRandomDuaUseCase {
    private let repository: UmmahDuaRepository
    
    public init(repository: UmmahDuaRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<UmmahResponse<RandomDuaResponse>, Error> {
        repository.getRandomDua()
    }
}
