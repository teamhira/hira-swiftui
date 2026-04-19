//
//  AddReadingSessionUseCase.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public protocol AddReadingSessionUseCase {
    func execute(chapterNumber: Int, verseNumber: Int) -> AnyPublisher<String, Error>
}

public class AddReadingSessionUseCaseImpl: AddReadingSessionUseCase {
    private let repository: ReadingSessionRepository
    
    public init(repository: ReadingSessionRepository) {
        self.repository = repository
    }
    
    public func execute(chapterNumber: Int, verseNumber: Int) -> AnyPublisher<String, Error> {
        return repository.addReadingSession(chapterNumber: chapterNumber, verseNumber: verseNumber)
    }
}
