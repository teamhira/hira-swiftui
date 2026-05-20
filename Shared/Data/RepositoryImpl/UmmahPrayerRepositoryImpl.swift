//
//  UmmahPrayerRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahPrayerRepositoryImpl: UmmahPrayerRepository {
    private let api: UmmahPrayerAPI
    
    public init(api: UmmahPrayerAPI) {
        self.api = api
    }
    
    public func getMethods() -> AnyPublisher<UmmahResponse<CalculationMethodsResponse>, Error> {
        api.getMethods()
    }
    
    public func getPrayerTimes(lat: Double, lng: Double, date: String?, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<PrayerTimesResponse>, Error> {
        api.getPrayerTimes(lat: lat, lng: lng, date: date, method: method, madhab: madhab, timezone: timezone)
    }
    
    public func getMonthlyTimetable(lat: Double, lng: Double, month: Int?, year: Int?, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<MonthlyTimetableResponse>, Error> {
        api.getMonthlyTimetable(lat: lat, lng: lng, month: month, year: year, method: method, madhab: madhab, timezone: timezone)
    }
    
    public func getRamadanTimetable(year: Int, lat: Double, lng: Double, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<RamadanTimetableResponse>, Error> {
        api.getRamadanTimetable(year: year, lat: lat, lng: lng, method: method, madhab: madhab, timezone: timezone)
    }
}
