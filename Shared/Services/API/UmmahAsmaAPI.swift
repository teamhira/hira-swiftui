//
//  UmmahAsmaAPI.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahAsmaAPI {
    private let client: UmmahClient
    
    public init(client: UmmahClient) {
        self.client = client
    }
    
    public func listNames() -> AnyPublisher<UmmahResponse<ListNamesResponse>, Error> {
        client.request(UmmahEndpoints.AsmaUlHusna.list)
    }
    
    public func getRandomName() -> AnyPublisher<UmmahResponse<SpecificNameResponse>, Error> {
        client.request(UmmahEndpoints.AsmaUlHusna.random)
    }
    
    public func searchNames(query: String) -> AnyPublisher<UmmahResponse<SearchNamesResponse>, Error> {
        let queryItems = [URLQueryItem(name: "query", value: query)]
        return client.request(UmmahEndpoints.AsmaUlHusna.search, queryItems: queryItems)
    }
    
    public func getSpecificName(id: Int) -> AnyPublisher<UmmahResponse<SpecificNameResponse>, Error> {
        client.request(UmmahEndpoints.AsmaUlHusna.specific(id: id))
    }
    
    public func getDailyRecitation() -> AnyPublisher<UmmahResponse<DailyRecitationResponse>, Error> {
        // API: 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
        // Swift: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        let weekday = Calendar.current.component(.weekday, from: Date())
        let apiDay = (weekday + 5) % 7 + 1
        return client.request(UmmahEndpoints.AsmaUlHusna.daily(day: apiDay))
    }
}
