//
//  GraphQLClient.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public struct GraphQLRequest: Codable {
    public let query: String
    public let variables: [String: AnyCodable]?
    
    public init(query: String, variables: [String: AnyCodable]? = nil) {
        self.query = query
        self.variables = variables
    }
}

public struct GraphQLResponse<T: Codable>: Codable {
    public let data: T?
    public let errors: [GraphQLErrorDetail]?
}

public struct GraphQLErrorDetail: Codable {
    public let message: String
}

public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let val = try? container.decode(String.self) { value = val }
        else if let val = try? container.decode(Int.self) { value = val }
        else if let val = try? container.decode(Double.self) { value = val }
        else if let val = try? container.decode(Bool.self) { value = val }
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value is not a basic type.") }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let val = value as? String { try container.encode(val) }
        else if let val = value as? Int { try container.encode(val) }
        else if let val = value as? Double { try container.encode(val) }
        else if let val = value as? Bool { try container.encode(val) }
        else { throw EncodingError.invalidValue(value, .init(codingPath: encoder.codingPath, debugDescription: "AnyCodable can only encode basic types.")) }
    }
}

public class GraphQLClient {
    private let url: URL
    private let session: URLSession
    
    public init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }
    
    public func execute<T: Codable>(_ query: String, variables: [String: AnyCodable]? = nil) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let graphQLRequest = GraphQLRequest(query: query, variables: variables)
        do {
            request.httpBody = try JSONEncoder().encode(graphQLRequest)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: GraphQLResponse<T>.self, decoder: JSONDecoder())
            .tryMap { response in
                if let errors = response.errors, !errors.isEmpty {
                    throw NetworkError.graphQLError(errors.map { $0.message })
                }
                guard let data = response.data else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
