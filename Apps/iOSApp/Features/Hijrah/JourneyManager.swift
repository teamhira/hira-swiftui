//
//  JourneyManager.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation

@Observable
public class JourneyManager {
    public static let shared = JourneyManager()
    
    public var state: JourneyState {
        didSet {
            save()
        }
    }
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: "HIRA_JOURNEY_CURRENT"),
           let decoded = try? JSONDecoder().decode(JourneyState.self, from: data) {
            self.state = decoded
        } else {
            self.state = JourneyState(type: .mualaf)
        }
    }
    
    public func completeMission(_ missionKey: String, expReward: Int) {
        guard !state.completedMissionIds.contains(missionKey) else { return }
        
        state.completedMissionIds.insert(missionKey)
        state.completionDates[missionKey] = Date()
        state.activeMissionIds.remove(missionKey)
        addJourneyXP(expReward)
        addGlobalXP(expReward / 2) // Journey missions also give small global progress
        
        checkAchievements()
        save()
    }
    
    private func addJourneyXP(_ amount: Int) {
        state.xp += amount
        while state.xp >= 100 {
            state.xp -= 100
            state.level += 1
            if state.level > 100 { state.level = 100 }
        }
    }
    
    private func addGlobalXP(_ amount: Int) {
        state.globalXP += amount
        while state.globalXP >= 500 {
            state.globalXP -= 500
            state.globalLevel += 1
            if state.globalLevel > 100 { state.globalLevel = 100 }
        }
    }
    
    public func unlockAchievement(_ id: Int, xpReward: Int) {
        guard !state.unlockedAchievementIds.contains(id) else { return }
        state.unlockedAchievementIds.insert(id)
        addGlobalXP(xpReward) // Achievements primarily drive Global level
        save()
    }
    
    private func checkAchievements() {
        // ID 1: Langkah Pertama (First mission completed)
        if state.completedMissionIds.count >= 1 {
            unlockAchievement(1, xpReward: 10)
        }
        
        // ID 3: Hari Pertama (Check if a Day 1 mission key is completed, e.g., m_d1_*)
        let completedD1 = state.completedMissionIds.filter { $0.contains("_d1_") }
        if !completedD1.isEmpty {
            unlockAchievement(3, xpReward: 15)
        }
    }
    
    public func followMission(_ missionKey: String) {
        state.activeMissionIds.insert(missionKey)
        save()
    }
    
    public func checkPracticeMission(type: MissionType, target: Int) {
        // Implementation for practice-based missions
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_JOURNEY_CURRENT")
        }
    }
}

