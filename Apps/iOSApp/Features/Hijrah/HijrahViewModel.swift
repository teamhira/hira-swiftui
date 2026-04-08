//
//  HijrahViewModel.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import Observation

@Observable
public class HijrahViewModel: Equatable, Hashable {
    public static func == (lhs: HijrahViewModel, rhs: HijrahViewModel) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    private var manager = JourneyManager.shared
    public var goals: [String] = []
    
    public var state: JourneyState { manager.state }
    
    public init(state: JourneyState) {
        // Initial state sync if needed, though we use the shared manager
        self.goals = UserDefaults.standard.stringArray(forKey: "HIRA_JOURNEY_GOALS") ?? []
    }
    
    public var currentLevelName: String {
        IslamicLevel.getLevelBaseName(for: state.level, type: state.type)
    }
    
    public var currentTierName: String {
        IslamicLevel.getLevelTierInfo(for: state.level).name
    }
    
    public var currentTierRoman: String {
        IslamicLevel.getLevelTierInfo(for: state.level).roman
    }
    
    public var currentTierColor: Color {
        Color(hex: IslamicLevel.getLevelTierInfo(for: state.level).colorHex)
    }
    
    public var journeyTypeName: String {
        switch state.type {
        case .mualaf: return "Mualaf"
        case .hijrah: return "Hijrah"
        case .better: return "Upgrade Diri"
        }
    }
    
    public var levelProgress: Double {
        Double(state.xp) / 100.0
    }
    
    public var dailyMissions: [Mission] {
        let list: [Mission]
        switch state.type {
        case .mualaf: list = HijrahMockData.mualafMissions
        case .hijrah: list = HijrahMockData.hijrahMissions
        case .better: list = HijrahMockData.betterMissions
        }
        
        return list
            .map { mission in
                var mod = mission
                mod.isCompleted = state.completedMissionIds.contains(mission.key)
                return mod
            }
            .sorted(by: { $0.order < $1.order })
    }
    
    
    public var weeklyMissions: [Mission] {
        // Implementation for weekly missions could follow the same pattern if needed
        []
    }
    
    public func isLocked(_ mission: Mission, in list: [Mission]) -> Bool {
        guard mission.order > 1 else { return false }
        let previousIdx = mission.order - 2
        return !list[previousIdx].isCompleted
    }
    
    public func completeMission(_ mission: Mission) {
        manager.completeMission(mission.key, expReward: mission.expReward)
    }
    
    public func followMission(_ mission: Mission) {
        manager.followMission(mission.key)
    }
    
    public func updateJourney(type: JourneyType, selectedGoals: [String]) {
        var newState = manager.state
        if newState.type != type || self.goals != selectedGoals {
            newState.level = 1
            newState.xp = 0
            newState.streak = 0
            newState.completedMissionIds.removeAll()
            newState.activeMissionIds.removeAll()
            newState.unlockedAchievementIds.removeAll()
        }
        
        newState.type = type
        manager.state = newState
        self.goals = selectedGoals
        UserDefaults.standard.set(selectedGoals, forKey: "HIRA_JOURNEY_GOALS")
    }
    
    public var achievements: [Achievement] {
        HijrahMockData.achievements
            .filter { $0.types.contains(state.type) }
            .map { ach in
                var mod = ach
                mod.isLocked = !state.unlockedAchievementIds.contains(ach.id)
                return mod
            }
            .sorted(by: { $0.order < $1.order })
    }
    

    public var suggestions: [Suggestion] {
        HijrahMockData.suggestions
            .filter { $0.targetJourneys.contains(state.type) }
    }
    

    
    // MARK: - Date & Prayer Info
    public var gregorianDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: Date())
    }
    
    public var hijriDate: String {
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: Date())
    }
    
    public var currentPrayerName: String { "Dzuhur" }
    public var currentPrayerTime: String { "11:58" }
    
    public var prayerTimes: [(name: String, time: String, active: Bool)] {
        [
            ("Subuh", "04:36", false),
            ("Dzuhur", "11:58", true),
            ("Ashar", "15:12", false),
            ("Maghrib", "18:02", false),
            ("Isya", "19:11", false)
        ]
    }
}
