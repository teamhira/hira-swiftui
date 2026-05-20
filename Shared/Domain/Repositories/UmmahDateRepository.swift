//
//  UmmahDateRepository.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol UmmahDateRepository {
    func getTodayHijri() -> AnyPublisher<UmmahResponse<TodayHijriResponse>, Error>
    func getIslamicMonths() -> AnyPublisher<UmmahResponse<IslamicMonthsResponse>, Error>
    func getIslamicEvents(year: Int?) -> AnyPublisher<UmmahResponse<IslamicEventsResponse>, Error>
    func convertHijriToGregorian(year: Int, month: Int, day: Int) -> AnyPublisher<UmmahResponse<DateConversionResponse>, Error>
    func convertGregorianToHijri(date: String?) -> AnyPublisher<UmmahResponse<DateConversionResponse>, Error>
}
