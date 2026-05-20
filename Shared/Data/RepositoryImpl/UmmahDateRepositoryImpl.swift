//
//  UmmahDateRepositoryImpl.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public class UmmahDateRepositoryImpl: UmmahDateRepository {
    private let api: UmmahDateAPI
    
    public init(api: UmmahDateAPI) {
        self.api = api
    }
    
    public func getTodayHijri() -> AnyPublisher<UmmahResponse<TodayHijriResponse>, Error> {
        api.getTodayHijri()
    }
    
    public func getIslamicMonths() -> AnyPublisher<UmmahResponse<IslamicMonthsResponse>, Error> {
        api.getIslamicMonths()
    }
    
    public func getIslamicEvents(year: Int?) -> AnyPublisher<UmmahResponse<IslamicEventsResponse>, Error> {
        api.getIslamicEvents(year: year)
    }
    
    public func convertHijriToGregorian(year: Int, month: Int, day: Int) -> AnyPublisher<UmmahResponse<DateConversionResponse>, Error> {
        api.convertHijriToGregorian(year: year, month: month, day: day)
    }
    
    public func convertGregorianToHijri(date: String?) -> AnyPublisher<UmmahResponse<DateConversionResponse>, Error> {
        api.convertGregorianToHijri(date: date)
    }
}
