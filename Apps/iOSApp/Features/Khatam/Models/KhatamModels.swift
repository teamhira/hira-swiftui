//
//  KhatamModels.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import Foundation

public struct KhatamLog: Identifiable, Codable {
    public let id: UUID
    public let date: Date
    public let startSurah: Int
    public let startAyah: Int
    public let endSurah: Int
    public let endAyah: Int
    public let ayahsRead: Int
    
    public init(id: UUID = UUID(), date: Date = Date(), startSurah: Int, startAyah: Int, endSurah: Int, endAyah: Int, ayahsRead: Int) {
        self.id = id
        self.date = date
        self.startSurah = startSurah
        self.startAyah = startAyah
        self.endSurah = endSurah
        self.endAyah = endAyah
        self.ayahsRead = ayahsRead
    }
}

public struct KhatamGoal: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var startDate: Date
    public var targetDate: Date
    public var totalAyahs: Int
    public var currentAyahCount: Int
    
    public var lastSurah: Int
    public var lastAyah: Int
    public var logs: [KhatamLog]
    
    public init(
        id: UUID = UUID(),
        title: String,
        startDate: Date = Date(),
        targetDate: Date,
        totalAyahs: Int = 6236,
        currentAyahCount: Int = 0,
        lastSurah: Int = 1,
        lastAyah: Int = 1,
        logs: [KhatamLog] = []
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.targetDate = targetDate
        self.totalAyahs = totalAyahs
        self.currentAyahCount = currentAyahCount
        self.lastSurah = lastSurah
        self.lastAyah = lastAyah
        self.logs = logs
    }

    
    public var progress: Double {
        Double(currentAyahCount) / Double(totalAyahs)
    }
    
    public var progressPercentage: Int {
        Int(progress * 100)
    }
    
    public var isCompleted: Bool {
        currentAyahCount >= totalAyahs
    }
    
    public var remainingAyahs: Int {
        max(0, totalAyahs - currentAyahCount)
    }
    
    public var daysRemaining: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)
        return max(1, components.day ?? 1)
    }
    
    public var dailyTarget: Int {
        Int(ceil(Double(remainingAyahs) / Double(daysRemaining)))
    }
    
    public var weeklyTarget: Int {
        dailyTarget * 7
    }
}

public struct KhatamHistoryRecord: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let completedDate: Date
    public let totalAyahs: Int
    public var logs: [KhatamLog]
    
    public init(id: UUID = UUID(), title: String, completedDate: Date = Date(), totalAyahs: Int = 6236, logs: [KhatamLog] = []) {
        self.id = id
        self.title = title
        self.completedDate = completedDate
        self.totalAyahs = totalAyahs
        self.logs = logs
    }
}

