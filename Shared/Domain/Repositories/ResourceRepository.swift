//
//  ResourceRepository.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine

public protocol ResourceRepository {
    func getLanguages() -> AnyPublisher<[LanguageResponse], Error>
    func getTafsirsList(language: String?) -> AnyPublisher<[TafsirResponse], Error>
    func getTranslationsList(language: String?) -> AnyPublisher<[TranslationResourceResponse], Error>
    func getRecitationsList(language: String?) -> AnyPublisher<[RecitationResponse], Error>
}
