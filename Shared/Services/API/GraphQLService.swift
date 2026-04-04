//
//  GraphQLService.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class GraphQLService {
    private let client: GraphQLClient
    
    public init(url: URL = AppConfig.graphqlURL) {
        self.client = GraphQLClient(url: url)
    }
    
    public func fetch<T: Codable>(query: String, variables: [String: AnyCodable]? = nil) -> AnyPublisher<T, Error> {
        return client.execute(query, variables: variables)
    }
}
