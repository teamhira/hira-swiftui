//
//  UmmahEndpoints.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct UmmahEndpoints {
    // MARK: - Dates
    public enum Dates {
        public static let today = "today-hijri"
        public static let months = "islamic-months"
        public static let events = "islamic-events"
        public static let hijriToGregorian = "gregorian-date"
        public static let gregorianToHijri = "hijri-date"
    }
    
    // MARK: - Hadith
    public enum Hadith {
        public static let collections = "hadith/collections"
        public static let random = "hadith/random"
        public static let search = "hadith/search"
        public static func browse(collection: String) -> String { "hadith/\(collection)" }
        public static func specific(collection: String, number: String) -> String { "hadith/\(collection)/\(number)" }
    }
    
    // MARK: - Prayer Times
    public enum PrayerTimes {
        public static let methods = "prayer-methods"
        public static let today = "prayer-times"
        public static let monthly = "prayer-times/month"
        public static func ramadan(year: Int) -> String { "ramadan/\(year)" }
    }
    
    // MARK: - Duas
    public enum Duas {
        public static let list = "duas"
        public static let categories = "duas/categories"
        public static let random = "duas/random"
        public static let search = "duas/search"
        public static func byCategory(id: String) -> String { "duas/category/\(id)" }
        public static func specific(id: Int) -> String { "duas/\(id)" }
    }
    
    // MARK: - Asma-ul-Husna
    public enum AsmaUlHusna {
        public static let list = "asma-ul-husna"
        public static let random = "asma-ul-husna/random"
        public static let search = "asma-ul-husna/search"
        public static func daily(day: Int) -> String { "asma-ul-husna/daily/\(day)" }
        public static func specific(id: Int) -> String { "asma-ul-husna/\(id)" }
    }
}
