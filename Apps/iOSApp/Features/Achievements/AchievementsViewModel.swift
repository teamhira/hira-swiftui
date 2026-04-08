//
//  AchievementsViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class AchievementsViewModel {
    // MARK: - Properties
    private let manager = JourneyManager.shared
    
    public var currentXP: Int {
        selectedCategory == "Global" ? manager.state.globalXP : manager.state.xp
    }
    
    public var maxXP: Int {
        selectedCategory == "Global" ? 500 : 100
    }
    
    public var level: Int {
        selectedCategory == "Global" ? manager.state.globalLevel : manager.state.level
    }
    
    public var levelName: String {
        if selectedCategory == "Global" {
            return "Spiritual"
        } else {
            return IslamicLevel.getLevelBaseName(for: manager.state.level, type: manager.state.type)
        }
    }
    
    public var isParticipatingInJourney: Bool {
        manager.state.type != .mualaf // Or some criteria
    }
    
    public var selectedCategory: String = "Global"
    
    // In a real app, these would come from a Service/Manager
    public var allAchievements: [Achievement] = [
        Achievement(
            id: 1,
            icon: "sun.max.fill",
            title: "Fajr Warrior",
            description: "Shalat Shubuh berjamaah selama 40 hari berturut-turut.",
            category: "Global",
            xp: 500,
            types: [.mualaf, .hijrah, .better],
            order: 1,
            isLocked: false
        ),
        Achievement(
            id: 2,
            icon: "book.fill",
            title: "Quran Reader",
            description: "Membaca Al-Quran setiap hari selama seminggu.",
            category: "Global",
            xp: 300,
            types: [.mualaf, .hijrah, .better],
            order: 2,
            isLocked: true
        ),
        Achievement(
            id: 3,
            icon: "heart.fill",
            title: "Generous Giver",
            description: "Berbagi sedekah melalui fitur Charity sebanyak 5 kali.",
            category: "Global",
            xp: 200,
            types: [.mualaf, .hijrah, .better],
            order: 3,
            isLocked: false
        ),
        Achievement(
            id: 4,
            icon: "figure.walk",
            title: "First Step",
            description: "Menyelesaikan kursus pengenalan Hijrah.",
            category: "Journey",
            xp: 100,
            types: [.hijrah],
            order: 4,
            isLocked: false
        ),
        Achievement(
            id: 5,
            icon: "flame.fill",
            title: "Consistent Mureed",
            description: "Menyelesaikan 10 misi harian berturut-turut.",
            category: "Journey",
            xp: 400,
            types: [.hijrah],
            order: 5,
            isLocked: true
        )
    ]
    
    // MARK: - Filtered Lists
    public var globalAchievements: [Achievement] {
        allAchievements.filter { $0.category == "Global" }
    }
    
    public var journeyAchievements: [Achievement] {
        allAchievements.filter { $0.category == "Journey" }
    }
    
    public var filteredAchievements: [Achievement] {
        allAchievements.filter { achievement in
            achievement.category == selectedCategory
        }
    }
    
    public var categories: [String] {
        if isParticipatingInJourney {
            return ["Global", "Journey"]
        } else {
            return ["Global"]
        }
    }
    
    // Simulate history
    public var history: [AchievementHistory] = [
        AchievementHistory(achievementId: 1, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        AchievementHistory(achievementId: 3, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
        AchievementHistory(achievementId: 4, date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!)
    ]
    
    public func history(for id: Int) -> AchievementHistory? {
        history.first { $0.achievementId == id }
    }
    
    public init() {}
}

public struct AchievementHistory: Identifiable, Hashable {
    public var id: Int { achievementId }
    public let achievementId: Int
    public let date: Date
}
