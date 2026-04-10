//
//  PrayerTimesViewModel.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI
import Observation

@Observable
public final class PrayerTimesViewModel {
    public var prayerTimes: [String: String] = [
        "Fajr": "04:30",
        "Sunrise": "05:45",
        "Dhuhr": "12:00",
        "Asr": "15:15",
        "Maghrib": "18:05",
        "Isha": "19:15"
    ]
    
    public init() {}
}
