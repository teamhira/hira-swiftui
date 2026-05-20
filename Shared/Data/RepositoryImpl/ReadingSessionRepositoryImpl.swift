//
//  ReadingSessionRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public class ReadingSessionRepositoryImpl: ReadingSessionRepository {
    private let api: ReadingSessionsAPI
    
    public init(api: ReadingSessionsAPI) {
        self.api = api
    }
    
    public func getReadingSessions(
        first: Int? = nil,
        after: String? = nil,
        last: Int? = nil,
        before: String? = nil
    ) -> AnyPublisher<([ReadingSessionEntity], ReadingSessionPagination?), Error> {
        return api.getReadingSessions(first: first, after: after, last: last, before: before)
            .map { response in
                let entities = response.data?.map { $0.toEntity() } ?? []
                return (entities, response.pagination)
            }
            .eraseToAnyPublisher()
    }
    
    public func addReadingSession(
        chapterNumber: Int,
        verseNumber: Int
    ) -> AnyPublisher<String, Error> {
        return api.addReadingSession(chapterNumber: chapterNumber, verseNumber: verseNumber)
            .map { response in
                response.data?.message ?? "Success"
            }
            .eraseToAnyPublisher()
    }
}
