//
//  ResourceRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public class ResourceRepositoryImpl: ResourceRepository {
    private let api: ResourceAPI
    private let database: DatabaseService
    
    public init(api: ResourceAPI, database: DatabaseService) {
        self.api = api
        self.database = database
    }
    
    public func getLanguages() -> AnyPublisher<[LanguageResponse], Error> {
        if let cached = database.fetchLanguages(), !cached.isEmpty {
            return Just(cached).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return api.getLanguages()
            .map { [database] (res: LanguagesResponse) in
                database.saveLanguages(res.languages)
                return res.languages
            }
            .eraseToAnyPublisher()
    }
    
    public func getTafsirsList(language: String?) -> AnyPublisher<[TafsirResponse], Error> {
        if let cached = database.fetchTafsirs(), !cached.isEmpty {
            return Just(cached).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return api.getTafsirsList(language: language)
            .map { [database] (res: TafsirResourceResponse) in
                database.saveTafsirs(res.tafsirs)
                return res.tafsirs
            }
            .eraseToAnyPublisher()
    }
    
    public func getTranslationsList(language: String?) -> AnyPublisher<[TranslationResourceResponse], Error> {
        if let cached = database.fetchResources(type: "translation"), !cached.isEmpty {
            return Just(cached).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return api.getTranslationsList(language: language)
            .map { [database] (res: TranslationResourcesResponse) in
                database.saveResources(res.translations, type: "translation")
                return res.translations
            }
            .eraseToAnyPublisher()
    }
    
    public func getRecitationsList(language: String?) -> AnyPublisher<[RecitationResponse], Error> {
        if let cached = database.fetchReciters(), !cached.isEmpty {
            return Just(cached).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return api.getRecitationsList(language: language)
            .map { [database] (res: RecitationsResponse) in
                database.saveReciters(res.recitations)
                return res.recitations
            }
            .eraseToAnyPublisher()
    }
}
