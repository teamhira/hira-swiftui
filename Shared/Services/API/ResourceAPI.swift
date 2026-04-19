//
//  ResourceAPI.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class ResourceAPI {
    private let client: FoundationClient
    
    public init(client: FoundationClient) {
        self.client = client
    }
    
    public func getLanguages() -> AnyPublisher<LanguagesResponse, Error> {
        return client.request(FoundationEndpoints.languages, method: .get)
    }
    
    public func getTafsirsList(language: String?) -> AnyPublisher<TafsirResourceResponse, Error> {
        var queryItems: [URLQueryItem]?
        if let lang = language { queryItems = [URLQueryItem(name: "language", value: lang)] }
        return client.request(FoundationEndpoints.tafsirs, method: .get, queryItems: queryItems)
    }
    
    public func getTranslationsList(language: String?) -> AnyPublisher<TranslationResourcesResponse, Error> {
        var queryItems: [URLQueryItem]?
        if let lang = language { queryItems = [URLQueryItem(name: "language", value: lang)] }
        return client.request(FoundationEndpoints.translations, method: .get, queryItems: queryItems)
    }
    
    public func getRecitationsList(language: String?) -> AnyPublisher<RecitationsResponse, Error> {
        var queryItems: [URLQueryItem]?
        if let lang = language { queryItems = [URLQueryItem(name: "language", value: lang)] }
        return client.request(FoundationEndpoints.recitations, method: .get, queryItems: queryItems)
    }
}
