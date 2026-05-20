//
//  GetActivityDaysUseCase.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public protocol GetActivityDaysUseCase {
    func execute(
        from: String?,
        to: String?,
        type: String?,
        first: Int?
    ) -> AnyPublisher<([ActivityDayEntity], ActivityDayPagination?), Error>
}

public extension GetActivityDaysUseCase {
    func execute(
        from: String? = nil,
        to: String? = nil,
        type: String? = "QURAN",
        first: Int? = 20
    ) -> AnyPublisher<([ActivityDayEntity], ActivityDayPagination?), Error> {
        execute(from: from, to: to, type: type, first: first)
    }
}

public class GetActivityDaysUseCaseImpl: GetActivityDaysUseCase {
    private let repository: ActivityDayRepository

    public init(repository: ActivityDayRepository) {
        self.repository = repository
    }

    public func execute(
        from: String?,
        to: String?,
        type: String?,
        first: Int?
    ) -> AnyPublisher<([ActivityDayEntity], ActivityDayPagination?), Error> {
        repository.getActivityDays(from: from, to: to, type: type, first: first, after: nil)
    }
}
