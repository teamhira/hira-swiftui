//
//  AuthRepository.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public protocol AuthRepository {
    func getUser(id: String) -> AnyPublisher<User, Error>
    func updateProfile(user: User) -> AnyPublisher<User, Error>
}
