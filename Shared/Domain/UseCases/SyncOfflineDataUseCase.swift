//
//  SyncOfflineDataUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class SyncOfflineDataUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<Void, Error> {
        // Implementation for syncing offline data
        return repository.getSurahs()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
