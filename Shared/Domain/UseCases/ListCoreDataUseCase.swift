//
//  ListCoreDataUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class ListCoreDataUseCase {
    private let repository: CoreRepository
    
    public init(repository: CoreRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<[CoreData], Error> {
        return repository.listCoreData()
    }
}
