//
//  UmmahAsmaRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahAsmaRepositoryImpl: UmmahAsmaRepository {
    private let api: UmmahAsmaAPI
    
    public init(api: UmmahAsmaAPI) {
        self.api = api
    }
    
    public func listNames() -> AnyPublisher<UmmahResponse<ListNamesResponse>, Error> {
        api.listNames()
    }
    
    public func getRandomName() -> AnyPublisher<UmmahResponse<SpecificNameResponse>, Error> {
        api.getRandomName()
    }
    
    public func searchNames(query: String) -> AnyPublisher<UmmahResponse<SearchNamesResponse>, Error> {
        api.searchNames(query: query)
    }
    
    public func getSpecificName(id: Int) -> AnyPublisher<UmmahResponse<SpecificNameResponse>, Error> {
        api.getSpecificName(id: id)
    }
    
    public func getDailyRecitation() -> AnyPublisher<UmmahResponse<DailyRecitationResponse>, Error> {
        api.getDailyRecitation()
    }
}
