//
//  AddBookmarkUseCase.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public protocol AddBookmarkUseCase {
    func execute(type: String, key: Int, verseNumber: Int?, isReading: Bool?, mushaf: Int) -> AnyPublisher<BookmarkEntity?, Error>
}

public class AddBookmarkUseCaseImpl: AddBookmarkUseCase {
    private let repository: BookmarkRepository
    
    public init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    public func execute(type: String, key: Int, verseNumber: Int?, isReading: Bool?, mushaf: Int) -> AnyPublisher<BookmarkEntity?, Error> {
        return repository.addBookmark(type: type, key: key, verseNumber: verseNumber, isReading: isReading, mushaf: mushaf)
    }
}
