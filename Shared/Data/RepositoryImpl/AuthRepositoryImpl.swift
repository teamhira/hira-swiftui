//
//  AuthRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class AuthRepositoryImpl: AuthRepository {
    private let client: GraphQLClient
    
    public init(client: GraphQLClient) {
        self.client = client
    }
    
    public func getUser(id: String) -> AnyPublisher<User, Error> {
        let query = """
        query GetUser($id: String!) {
            user(id: $id) {
                id
                username
                email
                role
            }
        }
        """
        
        let variables: [String: AnyCodable] = ["id": AnyCodable(id)]
        
        struct ResponseContainer: Codable {
            let user: User
        }
        
        return client.execute(query, variables: variables)
            .map { (container: ResponseContainer) in container.user }
            .eraseToAnyPublisher()
    }
    
    public func updateProfile(user: User) -> AnyPublisher<User, Error> {
        // Placeholder for mutation
        return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
