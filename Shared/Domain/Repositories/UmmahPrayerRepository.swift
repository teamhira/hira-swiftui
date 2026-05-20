//
//  UmmahPrayerRepository.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol UmmahPrayerRepository {
    func getMethods() -> AnyPublisher<UmmahResponse<CalculationMethodsResponse>, Error>
    func getPrayerTimes(lat: Double, lng: Double, date: String?, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<PrayerTimesResponse>, Error>
    func getMonthlyTimetable(lat: Double, lng: Double, month: Int?, year: Int?, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<MonthlyTimetableResponse>, Error>
    func getRamadanTimetable(year: Int, lat: Double, lng: Double, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<RamadanTimetableResponse>, Error>
}
