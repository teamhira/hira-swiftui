//
//  ReadingSessionRepository.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation
import Combine

public protocol ReadingSessionRepository {
    func getReadingSessions(
        first: Int?,
        after: String?,
        last: Int?,
        before: String?
    ) -> AnyPublisher<([ReadingSessionEntity], ReadingSessionPagination?), Error>
    
    func addReadingSession(
        chapterNumber: Int,
        verseNumber: Int
    ) -> AnyPublisher<String, Error>
}
