//
//  GetRandomHadithUseCase.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol GetRandomHadithUseCase {
    func execute(collection: String?) -> AnyPublisher<UmmahResponse<RandomHadithResponse>, Error>
}

public class GetRandomHadithUseCaseImpl: GetRandomHadithUseCase {
    private let repository: UmmahHadithRepository
    
    public init(repository: UmmahHadithRepository) {
        self.repository = repository
    }
    
    public func execute(collection: String? = nil) -> AnyPublisher<UmmahResponse<RandomHadithResponse>, Error> {
        repository.getRandomHadith(collection: collection)
    }
}
