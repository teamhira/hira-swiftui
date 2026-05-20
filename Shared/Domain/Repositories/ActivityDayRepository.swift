//
//  ActivityDayRepository.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public protocol ActivityDayRepository {
    func getActivityDays(
        from: String?,
        to: String?,
        type: String?,
        first: Int?,
        after: String?
    ) -> AnyPublisher<([ActivityDayEntity], ActivityDayPagination?), Error>

    func addActivityDay(
        type: String,
        seconds: Int,
        ranges: [String],
        mushafId: Int,
        date: String?,
        timezone: String?
    ) -> AnyPublisher<Void, Error>

    func estimateReadingTime(ranges: String) -> AnyPublisher<Double, Error>
}

public extension ActivityDayRepository {
    func getActivityDays(
        from: String? = nil,
        to: String? = nil,
        type: String? = "QURAN",
        first: Int? = 20,
        after: String? = nil
    ) -> AnyPublisher<([ActivityDayEntity], ActivityDayPagination?), Error> {
        getActivityDays(from: from, to: to, type: type, first: first, after: after)
    }
}
