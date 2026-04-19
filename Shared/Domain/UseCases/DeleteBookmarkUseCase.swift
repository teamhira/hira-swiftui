//
//  DeleteBookmarkUseCase.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public protocol DeleteBookmarkUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public class DeleteBookmarkUseCaseImpl: DeleteBookmarkUseCase {
    private let repository: BookmarkRepository
    
    public init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    public func execute(id: String) -> AnyPublisher<Void, Error> {
        return repository.deleteBookmark(id: id)
    }
}
