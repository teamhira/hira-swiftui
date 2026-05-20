//
//  UmmahDuaAPI.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahDuaAPI {
    private let client: UmmahClient
    
    public init(client: UmmahClient) {
        self.client = client
    }
    
    public func listDuas() -> AnyPublisher<UmmahResponse<ListDuasResponse>, Error> {
        client.request(UmmahEndpoints.Duas.list)
    }
    
    public func getCategories() -> AnyPublisher<UmmahResponse<DuaCategoriesResponse>, Error> {
        client.request(UmmahEndpoints.Duas.categories)
    }
    
    public func getRandomDua() -> AnyPublisher<UmmahResponse<RandomDuaResponse>, Error> {
        client.request(UmmahEndpoints.Duas.random)
    }
    
    public func searchDuas(query: String, category: String?) -> AnyPublisher<UmmahResponse<SearchDuasResponse>, Error> {
        var queryItems = [URLQueryItem(name: "query", value: query)]
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        return client.request(UmmahEndpoints.Duas.search, queryItems: queryItems)
    }
    
    public func getDuasByCategory(id: String) -> AnyPublisher<UmmahResponse<DuasByCategoryResponse>, Error> {
        client.request(UmmahEndpoints.Duas.byCategory(id: id))
    }
    
    public func getSpecificDua(id: Int) -> AnyPublisher<UmmahResponse<DuaItemResponse>, Error> {
        client.request(UmmahEndpoints.Duas.specific(id: id))
    }
}
