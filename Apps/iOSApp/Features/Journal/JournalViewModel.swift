//
//  JournalViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

public enum JournalMood: String, Codable, CaseIterable {
    case peaceful = "🌙"
    case grateful = "🤲"
    case spiritual = "🕌"
    case happy = "😊"
    case sad = "😔"
    
    public var titleKey: String {
        switch self {
        case .peaceful: return "journal_mood_peaceful"
        case .grateful: return "journal_mood_grateful"
        case .spiritual: return "journal_mood_spiritual"
        case .happy: return "journal_mood_happy"
        case .sad: return "journal_mood_sad"
        }
    }
    
    public var accessibilityLabel: String {
        switch self {
        case .peaceful: return "Peaceful"
        case .grateful: return "Grateful"
        case .spiritual: return "Spiritual"
        case .happy: return "Happy"
        case .sad: return "Sad"
        }
    }
}

public struct JournalEntry: Identifiable, Codable, Equatable {
    public let id: UUID
    public var title: String
    public var content: String
    public var reference: String?
    public var mood: JournalMood
    public var date: Date
    
    public init(id: UUID = UUID(), title: String, content: String, reference: String? = nil, mood: JournalMood = .peaceful, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.reference = reference
        self.mood = mood
        self.date = date
    }
    
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    public var monthLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
    
    public var preview: String {
        if content.count > 100 {
            return String(content.prefix(100)) + "..."
        }
        return content
    }
}

@Observable
public final class JournalViewModel {
    public var entries: [JournalEntry] = []
    public var isLoading: Bool = false
    
    private let storageKey = "hira_journal_entries"
    
    public init() {
        loadEntries()
    }
    
    public func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            self.entries = decoded.sorted(by: { $0.date > $1.date })
        } else {
            // Initial mock if empty
            if entries.isEmpty {
                 self.entries = [
                    JournalEntry(title: "Refleksi Surah Al-Kahf", content: "Sangat tersentuh dengan kisah pemuda gua hari ini, bagaimana mereka teguh dalam iman meski di tengah kesulitan. Sebuah pengingat bahwa Allah selalu memberi jalan keluar.", reference: "Al-Kahf: 10", mood: .spiritual, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
                    JournalEntry(title: "Syukur Hari Ini", content: "Alhamdulillah dapat sholat berjamaah tepat waktu hari ini. Rasanya hati jauh lebih tenang ketika mengutamakan panggilan-Nya.", mood: .grateful, date: Date())
                ]
                saveEntries()
            }
        }
    }
    
    public func addEntry(_ entry: JournalEntry) {
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    public func updateEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    public func deleteEntry(id: UUID) {
        entries.removeAll(where: { $0.id == id })
        saveEntries()
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
