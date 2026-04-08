//
//  CalendarViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class CalendarViewModel {
    public var hijriDate: String = "15 Shawwal 1447"
    public var gregorianDate: String = "Monday, 6 April 2026"
    public var importantDates: [String] = ["Idul Fitri", "Idul Adha", "Isra' Mi'raj", "Maulid Nabi"]
    
    public init() {}
}
