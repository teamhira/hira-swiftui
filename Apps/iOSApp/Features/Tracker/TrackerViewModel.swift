//
//  TrackerViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
public final class TrackerViewModel {
    public var todayEntries: [TrackerEntry] = []
    public var history: [TrackerDayHistory] = []
    public var isLoading: Bool = false
    
    private let storageKey = "hira_tracker_entries"
    private let historyKey = "hira_tracker_history"
    
    public static let shared = TrackerViewModel()
    
    public init() {
        loadData()
    }
    
    public func loadData() {
        isLoading = true
        
        // Load Today's Entries
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([TrackerEntry].self, from: data) {
            
            // Check if stored entries are for today
            let calendar = Calendar.current
            if let firstDate = decoded.first?.date, calendar.isDateInToday(firstDate) {
                self.todayEntries = decoded
            } else {
                // Archive yesterday's data to history if needed
                archiveTodayToHistory(entries: decoded)
                self.todayEntries = createDefaultTodayEntries()
            }
        } else {
            self.todayEntries = createDefaultTodayEntries()
        }
        
        // Load History
        if let historyData = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([TrackerDayHistory].self, from: historyData) {
            self.history = decodedHistory.sorted(by: { $0.dateString > $1.dateString })
        }
        
        isLoading = false
    }
    
    private func createDefaultTodayEntries() -> [TrackerEntry] {
        TrackerItemType.allCases.map { TrackerEntry(type: $0) }
    }
    
    public func toggleEntry(_ entry: TrackerEntry) {
        if let index = todayEntries.firstIndex(where: { $0.id == entry.id }) {
            todayEntries[index].isCompleted.toggle()
            saveTodayEntries()
        }
    }
    
    public func completeEntry(type: TrackerItemType) {
        if let index = todayEntries.firstIndex(where: { $0.type == type }) {
            if !todayEntries[index].isCompleted {
                todayEntries[index].isCompleted = true
                saveTodayEntries()
            }
        }
    }
    
    private func saveTodayEntries() {
        if let encoded = try? JSONEncoder().encode(todayEntries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func archiveTodayToHistory(entries: [TrackerEntry]) {
        guard let firstDate = entries.first?.date else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: firstDate)
        
        let newHistory = TrackerDayHistory(dateString: dateString, entries: entries)
        var currentHistory = history
        
        // Avoid duplicates
        if !currentHistory.contains(where: { $0.dateString == dateString }) {
            currentHistory.append(newHistory)
            self.history = currentHistory.sorted(by: { $0.dateString > $1.dateString })
            saveHistory()
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    // Total stats for Summary Card
    public var completionPercentage: Int {
        guard !todayEntries.isEmpty else { return 0 }
        let completed = todayEntries.filter { $0.isCompleted }.count
        return Int((Double(completed) / Double(todayEntries.count)) * 100)
    }
}
