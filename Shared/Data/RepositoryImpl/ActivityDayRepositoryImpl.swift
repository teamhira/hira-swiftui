//
//  ActivityDayRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public class ActivityDayRepositoryImpl: ActivityDayRepository {
    private let api: ActivityDaysAPI

    public init(api: ActivityDaysAPI) {
        self.api = api
    }

    public func getActivityDays(
        from: String?,
        to: String?,
        type: String?,
        first: Int?,
        after: String?
    ) -> AnyPublisher<([ActivityDayEntity], ActivityDayPagination?), Error> {
        api.getActivityDays(from: from, to: to, type: type, first: first, after: after)
            .map { response in
                let entities = response.data?.map { $0.toEntity() } ?? []
                return (entities, response.pagination)
            }
            .eraseToAnyPublisher()
    }

    public func addActivityDay(
        type: String,
        seconds: Int,
        ranges: [String],
        mushafId: Int,
        date: String?,
        timezone: String?
    ) -> AnyPublisher<Void, Error> {
        api.addActivityDay(
            type: type, seconds: seconds, ranges: ranges,
            mushafId: mushafId, date: date, timezone: timezone
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    public func estimateReadingTime(ranges: String) -> AnyPublisher<Double, Error> {
        api.estimateReadingTime(ranges: ranges)
            .map { response in response.data?.seconds ?? 0.0 }
            .eraseToAnyPublisher()
    }
}
