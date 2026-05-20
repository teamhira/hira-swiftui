//
//  DeenModeViewModel.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import Foundation
import Observation
import SwiftUI
import Combine

@Observable
public final class DeenModeViewModel {
    public static let shared = DeenModeViewModel()
    
    // MARK: - State
    public var isDeenModeActive: Bool = false
    public var selectedFocusType: DeenFocusType = .quran
    public var settings: [DeenSetting] = []
    public var activeSession: DeenFocusSession?
    public var history: [DeenFocusSession] = []
    
    // Timer related
    public var sessionDuration: Int = 0
    private var timer: AnyCancellable?
    
    private let settingsKey = "hira_deenmode_settings"
    private let historyKey = "hira_deenmode_history"
    
    public init() {
        loadSettings()
        loadHistory()
    }
    
    // MARK: - Actions
    public func toggleDeenMode() {
        if isDeenModeActive {
            stopSession()
        } else {
            startSession()
        }
        isDeenModeActive.toggle()
    }
    
    private func startSession() {
        activeSession = DeenFocusSession(type: selectedFocusType)
        sessionDuration = 0
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.sessionDuration += 1
            }
        
        applySettings(active: true)
        showFocusNotification()
    }
    
    private func stopSession() {
        guard var session = activeSession else { return }
        session.endTime = Date()
        session.durationSeconds = sessionDuration
        
        history.append(session)
        saveHistory()
        
        activeSession = nil
        timer?.cancel()
        timer = nil
        
        applySettings(active: false)
        removeFocusNotification()
    }
    
    private func showFocusNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("deenmode_active_title", comment: "")
        content.body = NSLocalizedString("deenmode_active_desc", comment: "")
        content.sound = nil // Minimalist, quiet
        content.userInfo = ["feature": "deenmode"]
        
        // Use a time interval trigger that fires almost immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "DEEN_MODE_FOCUS", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func removeFocusNotification() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["DEEN_MODE_FOCUS"])
    }
    
    public func toggleSetting(at index: Int) {
        settings[index].isActive.toggle()
        saveSettings()
        
        if isDeenModeActive {
            applySettings(active: true)
        }
    }
    
    private func applySettings(active: Bool) {
        // Mute Notification (MOCK: In real app would use DND API if possible)
        // AOD (UIApplication.shared.isIdleTimerDisabled)
        if let aodSetting = settings.first(where: { $0.titleKey == "deenmode_setting_aod" }), aodSetting.isActive {
            UIApplication.shared.isIdleTimerDisabled = active
        }
    }
    
    // MARK: - Persistence
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode([DeenSetting].self, from: data) {
            self.settings = decoded
        } else {
            self.settings = [
                DeenSetting(titleKey: "deenmode_setting_mute", descKey: "deenmode_setting_mute_desc", icon: "bell.slash.fill", isActive: true),
                DeenSetting(titleKey: "deenmode_setting_aod", descKey: "deenmode_setting_aod_desc", icon: "sun.max.fill", isActive: true),
                DeenSetting(titleKey: "deenmode_setting_airplane", descKey: "deenmode_setting_airplane_desc", icon: "airplane", isActive: false),
                DeenSetting(titleKey: "deenmode_setting_stats", descKey: "deenmode_setting_stats_desc", icon: "chart.bar.fill", isActive: true)
            ]
            saveSettings()
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([DeenFocusSession].self, from: data) {
            self.history = decoded
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    // MARK: - Helpers
    public var totalFocusTimeSeconds: Int {
        history.reduce(0) { $0 + $1.durationSeconds }
    }
    
    public func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%02d:%02d", minutes, remainingSeconds)
        }
    }
}
