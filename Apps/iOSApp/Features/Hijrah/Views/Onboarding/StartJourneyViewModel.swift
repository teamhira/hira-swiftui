//
//  StartJourneyViewModel.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import Observation

enum OnboardingStep {
    case phaseSelection
    case emotionalHook
    case goalSetting
    case commitment
}

@Observable
class StartJourneyViewModel {
    var currentStep: OnboardingStep = .phaseSelection
    var selectedType: JourneyType? = nil
    var selectedGoals: Set<String> = []
    
    init() {}
    
    var availableGoals: [String] {
        guard let type = selectedType else { return [] }
        switch type {
        case .mualaf:
            return ["hijrah_goal_zero", "hijrah_goal_shalat", "hijrah_goal_allah", "hijrah_goal_consistency"]
        case .hijrah:
            return ["hijrah_goal_shalat", "hijrah_goal_allah", "hijrah_goal_consistency", "hijrah_goal_zero"]
        case .better:
            return ["hijrah_goal_shalat", "hijrah_goal_allah", "hijrah_goal_consistency"]
        }
    }
    
    func nextStep() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            switch currentStep {
            case .phaseSelection:
                if selectedType != nil { currentStep = .emotionalHook }
            case .emotionalHook:
                currentStep = .goalSetting
            case .goalSetting:
                if !selectedGoals.isEmpty { currentStep = .commitment }
            case .commitment:
                // Handled in View with router.navigate
                break
            }
        }
    }
    
    func previousStep() {
        withAnimation(.spring()) {
            switch currentStep {
            case .phaseSelection: break
            case .emotionalHook: currentStep = .phaseSelection
            case .goalSetting: currentStep = .emotionalHook
            case .commitment: currentStep = .goalSetting
            }
        }
    }
    
    func toggleGoal(_ goal: String) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }
    
    func completeOnboarding() -> JourneyState? {
        guard let type = selectedType else { return nil }
        
        let initialState = JourneyState(
            type: type,
            day: 1,
            level: 1,
            xp: 0,
            streak: 0
        )
        
        if let encoded = try? JSONEncoder().encode(initialState) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_JOURNEY_STATE")
            UserDefaults.standard.set(true, forKey: "HIRA_HAS_COMPLETED_ONBOARDING")
            
            // Personalize goals as well
            UserDefaults.standard.set(Array(selectedGoals), forKey: "HIRA_JOURNEY_GOALS")
        }
        
        return initialState
    }
}
