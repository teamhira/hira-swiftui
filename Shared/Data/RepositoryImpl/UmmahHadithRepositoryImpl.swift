//
//  UmmahHadithRepository.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahHadithRepositoryImpl: UmmahHadithRepository {
    private let api: UmmahHadithAPI
    
    public init(api: UmmahHadithAPI) {
        self.api = api
    }
    
    public func listCollections() -> AnyPublisher<UmmahResponse<HadithCollectionsResponse>, Error> {
        api.listCollections()
    }
    
    public func browseCollection(collection: String, page: Int?) -> AnyPublisher<UmmahResponse<BrowseCollectionResponse>, Error> {
        api.browseCollection(collection: collection, page: page)
    }
    
    public func getRandomHadith(collection: String?) -> AnyPublisher<UmmahResponse<RandomHadithResponse>, Error> {
        api.getRandomHadith(collection: collection)
    }
    
    public func getSpecificHadith(collection: String, number: String) -> AnyPublisher<UmmahResponse<SpecificHadithResponse>, Error> {
        api.getSpecificHadith(collection: collection, number: number)
    }
    
    public func searchHadiths(query: String, collection: String?) -> AnyPublisher<UmmahResponse<SearchHadithsResponse>, Error> {
        api.searchHadiths(query: query, collection: collection)
    }
}
