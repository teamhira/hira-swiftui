//
//  GetCoreDataUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class GetCoreDataUseCase {
    private let repository: CoreRepository
    
    public init(repository: CoreRepository) {
        self.repository = repository
    }
    
    public func execute(id: String) -> AnyPublisher<CoreData, Error> {
        return repository.getCoreData(id: id)
    }
}
