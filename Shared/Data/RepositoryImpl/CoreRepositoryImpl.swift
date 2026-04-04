//
//  CoreRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class CoreRepositoryImpl: CoreRepository {
    private let client: GraphQLClient
    
    public init(client: GraphQLClient) {
        self.client = client
    }
    
    public func getCoreData(id: String) -> AnyPublisher<CoreData, Error> {
        let query = """
        query GetCoreData($id: String!) {
            coreData(id: $id) {
                id
                title
                description
            }
        }
        """
        
        let variables: [String: AnyCodable] = ["id": AnyCodable(id)]
        
        struct ResponseContainer: Codable {
            let coreData: CoreData
        }
        
        return client.execute(query, variables: variables)
            .map { (container: ResponseContainer) in container.coreData }
            .eraseToAnyPublisher()
    }
    
    public func listCoreData() -> AnyPublisher<[CoreData], Error> {
        let query = """
        query ListCoreData {
            listCoreData {
                id
                title
                description
            }
        }
        """
        
        struct ResponseContainer: Codable {
            let listCoreData: [CoreData]
        }
        
        return client.execute(query)
            .map { (container: ResponseContainer) in container.listCoreData }
            .eraseToAnyPublisher()
    }
}
