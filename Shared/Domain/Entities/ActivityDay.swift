//
//  ActivityDay.swift
//  Hira
//
//  Created by Antigravity on 17/04/26.
//

import Foundation

// MARK: - Entity

public struct ActivityDayEntity: Identifiable, Codable, Hashable {
    public let id: String
    public let date: String            // YYYY-MM-DD
    public let progress: Double        // 0.0 – 1.0 (goal completion)
    public let type: String            // "QURAN" | "LESSON" | "QURAN_READING_PROGRAM"
    public let ranges: [String]        // ["1:1-1:7", ...]
    public let pagesRead: Double
    public let secondsRead: Int
    public let versesRead: Int
    public let manuallyAddedSeconds: Int
    public let dailyTargetPages: Double
    public let dailyTargetSeconds: Int
    public let dailyTargetRanges: [String]
    public let remainingDailyTargetRanges: [String]
    public let mushafId: Int?

    public init(
        id: String, date: String, progress: Double, type: String,
        ranges: [String], pagesRead: Double, secondsRead: Int, versesRead: Int,
        manuallyAddedSeconds: Int, dailyTargetPages: Double, dailyTargetSeconds: Int,
        dailyTargetRanges: [String], remainingDailyTargetRanges: [String], mushafId: Int?
    ) {
        self.id = id; self.date = date; self.progress = progress; self.type = type
        self.ranges = ranges; self.pagesRead = pagesRead; self.secondsRead = secondsRead
        self.versesRead = versesRead; self.manuallyAddedSeconds = manuallyAddedSeconds
        self.dailyTargetPages = dailyTargetPages; self.dailyTargetSeconds = dailyTargetSeconds
        self.dailyTargetRanges = dailyTargetRanges
        self.remainingDailyTargetRanges = remainingDailyTargetRanges; self.mushafId = mushafId
    }

    /// Parses the `date` string into a `Date` object (midnight UTC).
    public var parsedDate: Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.timeZone = TimeZone(identifier: "UTC")
        return fmt.date(from: date) ?? Date()
    }
}

// MARK: - API Response Models

public struct ActivityDaysResponse: Codable {
    public let success: Bool
    public let data: [ActivityDayModel]?
    public let pagination: ActivityDayPagination?
}

public struct ActivityDayPostResponse: Codable {
    public let success: Bool
    public let data: ActivityDayPostData?
}

public struct ActivityDayPostData: Codable {
    // The API returns an empty object on success
}

public struct ActivityDayEstimateResponse: Codable {
    public let success: Bool
    public let data: ActivityDayEstimateData?
}

public struct ActivityDayEstimateData: Codable {
    public let seconds: Double
}

public struct ActivityDayModel: Codable {
    public let id: String
    public let date: String
    public let progress: Double?
    public let type: String?
    public let ranges: [String]?
    public let pagesRead: Double?
    public let secondsRead: Int?
    public let versesRead: Int?
    public let manuallyAddedSeconds: Int?
    public let dailyTargetPages: Double?
    public let dailyTargetSeconds: Int?
    public let dailyTargetRanges: [String]?
    public let remainingDailyTargetRanges: [String]?
    public let mushafId: Int?

    public func toEntity() -> ActivityDayEntity {
        ActivityDayEntity(
            id: id,
            date: date,
            progress: progress ?? 0,
            type: type ?? "QURAN",
            ranges: ranges ?? [],
            pagesRead: pagesRead ?? 0,
            secondsRead: secondsRead ?? 0,
            versesRead: versesRead ?? 0,
            manuallyAddedSeconds: manuallyAddedSeconds ?? 0,
            dailyTargetPages: dailyTargetPages ?? 0,
            dailyTargetSeconds: dailyTargetSeconds ?? 0,
            dailyTargetRanges: dailyTargetRanges ?? [],
            remainingDailyTargetRanges: remainingDailyTargetRanges ?? [],
            mushafId: mushafId
        )
    }
}

public struct ActivityDayPagination: Codable {
    public let startCursor: String?
    public let endCursor: String?
    public let hasNextPage: Bool
    public let hasPreviousPage: Bool
}
