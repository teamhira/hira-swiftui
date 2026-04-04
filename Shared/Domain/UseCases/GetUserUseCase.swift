//
//  GetUserUseCase.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class GetUserUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(id: String) -> AnyPublisher<User, Error> {
        return repository.getUser(id: id)
    }
}
