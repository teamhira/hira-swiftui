//
//  UmmahHadithAPI.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahHadithAPI {
    private let client: UmmahClient
    
    public init(client: UmmahClient) {
        self.client = client
    }
    
    public func listCollections() -> AnyPublisher<UmmahResponse<HadithCollectionsResponse>, Error> {
        client.request(UmmahEndpoints.Hadith.collections)
    }
    
    public func browseCollection(collection: String, page: Int?) -> AnyPublisher<UmmahResponse<BrowseCollectionResponse>, Error> {
        var queryItems: [URLQueryItem]?
        if let page = page {
            queryItems = [URLQueryItem(name: "page", value: String(page))]
        }
        return client.request(UmmahEndpoints.Hadith.browse(collection: collection), queryItems: queryItems)
    }
    
    public func getRandomHadith(collection: String?) -> AnyPublisher<UmmahResponse<RandomHadithResponse>, Error> {
        var queryItems: [URLQueryItem]?
        if let collection = collection {
            queryItems = [URLQueryItem(name: "collection", value: collection)]
        }
        return client.request(UmmahEndpoints.Hadith.random, queryItems: queryItems)
    }
    
    public func getSpecificHadith(collection: String, number: String) -> AnyPublisher<UmmahResponse<SpecificHadithResponse>, Error> {
        client.request(UmmahEndpoints.Hadith.specific(collection: collection, number: number))
    }
    
    public func searchHadiths(query: String, collection: String?) -> AnyPublisher<UmmahResponse<SearchHadithsResponse>, Error> {
        var queryItems = [URLQueryItem(name: "query", value: query)]
        if let collection = collection {
            queryItems.append(URLQueryItem(name: "collection", value: collection))
        }
        return client.request(UmmahEndpoints.Hadith.search, queryItems: queryItems)
    }
}
