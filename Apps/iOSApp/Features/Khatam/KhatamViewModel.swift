//
//  KhatamViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation
import SwiftUI
import Combine

@Observable
public final class KhatamViewModel {
    // MARK: - Dependencies
    private let getSurahListUseCase: GetSurahListUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Mock Data
    private let surahAyahCounts: [Int] = [
        7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128, 111, 110, 98, 135,
        112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53,
        89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12,
        12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19, 26,
        30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6
    ]
    
    // MARK: - State
    public var activeGoal: KhatamGoal?
    public var history: [KhatamHistoryRecord] = []
    public var surahs: [Surah] = []
    public var isLoading: Bool = false
    
    // Calculated Ranges for UI
    public var dailyRange: String = ""
    public var weeklyRange: String = ""
    public var footerRange: String = ""
    
    // MARK: - Initialization
    public init(
        getSurahListUseCase: GetSurahListUseCase = DIContainer.shared.getSurahListUseCase
    ) {
        self.getSurahListUseCase = getSurahListUseCase
        loadData()
        fetchSurahs()
    }
    
    // MARK: - Actions
    public func fetchSurahs() {
        getSurahListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] surahs in
                self?.surahs = surahs
            }
            .store(in: &cancellables)
    }
    
    public func createGoal(title: String, startDate: Date, targetDate: Date, startSurah: Int, startAyah: Int) {
        let initialAyahs = calculateAyahsBefore(surah: startSurah, ayah: startAyah)
        let newGoal = KhatamGoal(
            title: title, 
            startDate: startDate, 
            targetDate: targetDate, 
            currentAyahCount: initialAyahs,
            lastSurah: startSurah, 
            lastAyah: startAyah
        )
        self.activeGoal = newGoal
        saveData()
    }
    
    private func calculateAyahsBefore(surah: Int, ayah: Int) -> Int {
        var total = 0
        if surah > 1 {
            for i in 1..<surah {
                total += surahAyahCounts[safe: i - 1] ?? 0
            }
        }
        total += max(0, ayah - 1)
        return total
    }

    
    public func addManualRangeProgress(fromSurah: Int, fromAyah: Int, toSurah: Int, toAyah: Int, completion: @escaping () -> Void) {
        guard var goal = activeGoal else { 
            completion()
            return 
        }
        
        isLoading = true
        
        // MOCK CALCULATION: Calculate total ayahs in range
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let ayahsRead = self.calculateAyahsInRange(
                fromSurah: fromSurah, fromAyah: fromAyah, 
                toSurah: toSurah, toAyah: toAyah
            )
            
            let log = KhatamLog(
                startSurah: fromSurah,
                startAyah: fromAyah,
                endSurah: toSurah,
                endAyah: toAyah,
                ayahsRead: ayahsRead
            )
            
            DispatchQueue.main.async {
                goal.logs.append(log)
                goal.currentAyahCount = min(goal.currentAyahCount + ayahsRead, goal.totalAyahs)
                goal.lastSurah = toSurah
                goal.lastAyah = toAyah
                
                TrackerViewModel.shared.completeEntry(type: .quran)
                
                if goal.isCompleted {
                    self.completeGoal(goal)
                } else {
                    self.activeGoal = goal
                    self.saveData()
                }
                self.isLoading = false
                completion()
            }
        }
    }
    
    private func calculateAyahsInRange(fromSurah: Int, fromAyah: Int, toSurah: Int, toAyah: Int) -> Int {
        // If same surah
        if fromSurah == toSurah {
            return max(1, toAyah - fromAyah + 1)
        }
        
        var total = 0
        
        // 1. Ayahs from start surah
        let startSurahMax = surahAyahCounts[safe: fromSurah - 1] ?? 0
        total += max(0, startSurahMax - fromAyah + 1)
        
        // 2. Ayahs from intermediate surahs
        if toSurah > fromSurah + 1 {
            for i in (fromSurah + 1)..<toSurah {
                total += surahAyahCounts[safe: i - 1] ?? 0
            }
        }
        
        // 3. Ayahs from end surah
        total += toAyah
        
        return total
    }
    
    private func completeGoal(_ goal: KhatamGoal) {
        let historyRecord = KhatamHistoryRecord(
            title: goal.title,
            completedDate: Date(),
            totalAyahs: goal.totalAyahs,
            logs: goal.logs
        )
        history.insert(historyRecord, at: 0)
        activeGoal = nil
        saveData()
    }
    
    // MARK: - Range Calculation (MOCK)
    public func calculateRanges(goal: KhatamGoal) {
        let nextStartSurah = goal.lastSurah
        let nextStartAyah = goal.lastAyah + (goal.currentAyahCount > 0 ? 1 : 0)
        
        self.dailyRange = mockRangeString(startingFrom: nextStartSurah, ayah: nextStartAyah, count: goal.dailyTarget)
        self.weeklyRange = mockRangeString(startingFrom: nextStartSurah, ayah: nextStartAyah, count: goal.weeklyTarget)
        self.footerRange = "" 
    }
    
    private func mockRangeString(startingFrom surah: Int, ayah: Int, count: Int) -> String {
        var currentSurah = surah
        var currentAyah = ayah
        var remaining = count
        
        // Adjust if currentAyah exceeds surah count
        while currentSurah <= 114 {
            let maxAyahForSurah = surahAyahCounts[safe: currentSurah - 1] ?? 0
            if currentAyah > maxAyahForSurah {
                currentSurah += 1
                currentAyah = 1
            } else {
                break
            }
        }
        
        if currentSurah > 114 { return "..." }
        
        let startSurahName = getSurahName(id: currentSurah)
        let startAyahNum = currentAyah
        
        // Find end
        while remaining > 0 && currentSurah <= 114 {
            let maxAyahForSurah = surahAyahCounts[safe: currentSurah - 1] ?? 0
            let availableInCurrent = maxAyahForSurah - currentAyah + 1
            
            if remaining <= availableInCurrent {
                currentAyah = currentAyah + remaining - 1
                remaining = 0
            } else {
                remaining -= availableInCurrent
                currentSurah += 1
                currentAyah = 1
            }
        }
        
        let finalSurah = min(114, currentSurah)
        let endSurahName = getSurahName(id: finalSurah)
        let endAyahNum = currentAyah
        
        return "\(startSurahName) \(startAyahNum) → \(endSurahName) \(endAyahNum)"
    }

    
    public func getSurahName(id: Int) -> String {
        return surahs.first(where: { $0.number == id })?.name ?? "..."
    }
    
    public func getSurahVersesCount(id: Int) -> Int {
        return surahAyahCounts[safe: id - 1] ?? 286
    }
    
    public func deleteCurrentGoal() {

        activeGoal = nil
        saveData()
    }
    
    // MARK: - Persistence
    private func saveData() {
        if let encodedGoal = try? JSONEncoder().encode(activeGoal) {
            UserDefaults.standard.set(encodedGoal, forKey: "HIRA_KHATAM_ACTIVE_GOAL")
        } else {
            UserDefaults.standard.removeObject(forKey: "HIRA_KHATAM_ACTIVE_GOAL")
        }
        
        if let encodedHistory = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedHistory, forKey: "HIRA_KHATAM_HISTORY")
        }
    }
    
    private func loadData() {
        if let goalData = UserDefaults.standard.data(forKey: "HIRA_KHATAM_ACTIVE_GOAL"),
           let decodedGoal = try? JSONDecoder().decode(KhatamGoal.self, from: goalData) {
            self.activeGoal = decodedGoal
        }
        
        if let historyData = UserDefaults.standard.data(forKey: "HIRA_KHATAM_HISTORY"),
           let decodedHistory = try? JSONDecoder().decode([KhatamHistoryRecord].self, from: historyData) {
            self.history = decodedHistory
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

