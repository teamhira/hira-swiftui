//
//  GetPrayerTimesUseCase.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol GetPrayerTimesUseCase {
    func execute(lat: Double, lng: Double, method: String?) -> AnyPublisher<UmmahResponse<PrayerTimesResponse>, Error>
}

public class GetPrayerTimesUseCaseImpl: GetPrayerTimesUseCase {
    private let repository: UmmahPrayerRepository
    
    public init(repository: UmmahPrayerRepository) {
        self.repository = repository
    }
    
    public func execute(lat: Double, lng: Double, method: String?) -> AnyPublisher<UmmahResponse<PrayerTimesResponse>, Error> {
        repository.getPrayerTimes(
            lat: lat,
            lng: lng,
            date: nil,
            method: method,
            madhab: nil,
            timezone: TimeZone.current.identifier
        )
    }
}
