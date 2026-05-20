//
//  UmmahPrayerAPI.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahPrayerAPI {
    private let client: UmmahClient
    
    public init(client: UmmahClient) {
        self.client = client
    }
    
    public func getMethods() -> AnyPublisher<UmmahResponse<CalculationMethodsResponse>, Error> {
        client.request(UmmahEndpoints.PrayerTimes.methods)
    }
    
    public func getPrayerTimes(lat: Double, lng: Double, date: String?, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<PrayerTimesResponse>, Error> {
        var queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(lng))
        ]
        if let date = date { queryItems.append(URLQueryItem(name: "date", value: date)) }
        if let method = method { queryItems.append(URLQueryItem(name: "method", value: method)) }
        if let madhab = madhab { queryItems.append(URLQueryItem(name: "madhab", value: madhab)) }
        if let timezone = timezone { queryItems.append(URLQueryItem(name: "timezone", value: timezone)) }
        
        return client.request(UmmahEndpoints.PrayerTimes.today, queryItems: queryItems)
    }
    
    public func getMonthlyTimetable(lat: Double, lng: Double, month: Int?, year: Int?, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<MonthlyTimetableResponse>, Error> {
        var queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(lng))
        ]
        if let month = month { queryItems.append(URLQueryItem(name: "month", value: String(month))) }
        if let year = year { queryItems.append(URLQueryItem(name: "year", value: String(year))) }
        if let method = method { queryItems.append(URLQueryItem(name: "method", value: method)) }
        if let madhab = madhab { queryItems.append(URLQueryItem(name: "madhab", value: madhab)) }
        if let timezone = timezone { queryItems.append(URLQueryItem(name: "timezone", value: timezone)) }
        
        return client.request(UmmahEndpoints.PrayerTimes.monthly, queryItems: queryItems)
    }
    
    public func getRamadanTimetable(year: Int, lat: Double, lng: Double, method: String?, madhab: String?, timezone: String?) -> AnyPublisher<UmmahResponse<RamadanTimetableResponse>, Error> {
        var queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(lng))
        ]
        if let method = method { queryItems.append(URLQueryItem(name: "method", value: method)) }
        if let madhab = madhab { queryItems.append(URLQueryItem(name: "madhab", value: madhab)) }
        if let timezone = timezone { queryItems.append(URLQueryItem(name: "timezone", value: timezone)) }
        
        return client.request(UmmahEndpoints.PrayerTimes.ramadan(year: year), queryItems: queryItems)
    }
}
