//
//  AddActivityDayUseCase.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

public protocol AddActivityDayUseCase {
    func execute(
        type: String,
        seconds: Int,
        ranges: [String],
        mushafId: Int,
        date: String?,
        timezone: String?
    ) -> AnyPublisher<Void, Error>
}

public extension AddActivityDayUseCase {
    func execute(
        type: String = "QURAN",
        seconds: Int,
        ranges: [String],
        mushafId: Int = 4,
        date: String? = nil,
        timezone: String? = TimeZone.current.identifier
    ) -> AnyPublisher<Void, Error> {
        execute(type: type, seconds: seconds, ranges: ranges, mushafId: mushafId, date: date, timezone: timezone)
    }
}

public class AddActivityDayUseCaseImpl: AddActivityDayUseCase {
    private let repository: ActivityDayRepository

    public init(repository: ActivityDayRepository) {
        self.repository = repository
    }

    public func execute(
        type: String,
        seconds: Int,
        ranges: [String],
        mushafId: Int,
        date: String?,
        timezone: String?
    ) -> AnyPublisher<Void, Error> {
        repository.addActivityDay(
            type: type, seconds: seconds, ranges: ranges,
            mushafId: mushafId, date: date, timezone: timezone
        )
    }
}
