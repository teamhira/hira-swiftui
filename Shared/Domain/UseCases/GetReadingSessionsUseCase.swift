//
//  GetReadingSessionsUseCase.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public protocol GetReadingSessionsUseCase {
    func execute(first: Int?, after: String?, last: Int?, before: String?) -> AnyPublisher<([ReadingSessionEntity], ReadingSessionPagination?), Error>
}

public class GetReadingSessionsUseCaseImpl: GetReadingSessionsUseCase {
    private let repository: ReadingSessionRepository
    
    public init(repository: ReadingSessionRepository) {
        self.repository = repository
    }
    
    public func execute(first: Int? = nil, after: String? = nil, last: Int? = nil, before: String? = nil) -> AnyPublisher<([ReadingSessionEntity], ReadingSessionPagination?), Error> {
        return repository.getReadingSessions(first: first, after: after, last: last, before: before)
    }
}
