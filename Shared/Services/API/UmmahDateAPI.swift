//
//  UmmahDateAPI.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahDateAPI {
    private let client: UmmahClient
    
    public init(client: UmmahClient) {
        self.client = client
    }
    
    public func getTodayHijri() -> AnyPublisher<UmmahResponse<TodayHijriResponse>, Error> {
        client.request(UmmahEndpoints.Dates.today)
    }
    
    public func getIslamicMonths() -> AnyPublisher<UmmahResponse<IslamicMonthsResponse>, Error> {
        client.request(UmmahEndpoints.Dates.months)
    }
    
    public func getIslamicEvents(year: Int?) -> AnyPublisher<UmmahResponse<IslamicEventsResponse>, Error> {
        var queryItems: [URLQueryItem]?
        if let year = year {
            queryItems = [URLQueryItem(name: "year", value: String(year))]
        }
        return client.request(UmmahEndpoints.Dates.events, queryItems: queryItems)
    }
    
    public func convertHijriToGregorian(year: Int, month: Int, day: Int) -> AnyPublisher<UmmahResponse<DateConversionResponse>, Error> {
        let queryItems = [
            URLQueryItem(name: "year", value: String(year)),
            URLQueryItem(name: "month", value: String(month)),
            URLQueryItem(name: "day", value: String(day))
        ]
        return client.request(UmmahEndpoints.Dates.hijriToGregorian, queryItems: queryItems)
    }
    
    public func convertGregorianToHijri(date: String?) -> AnyPublisher<UmmahResponse<DateConversionResponse>, Error> {
        var queryItems: [URLQueryItem]?
        if let date = date {
            queryItems = [URLQueryItem(name: "date", value: date)]
        }
        return client.request(UmmahEndpoints.Dates.gregorianToHijri, queryItems: queryItems)
    }
}
