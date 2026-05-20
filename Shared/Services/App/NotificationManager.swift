//
//  NotificationManager.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import UserNotifications
import UIKit

public class NotificationManager: NSObject {
    public static let shared = NotificationManager()
    
    private override init() {
        super.init()
        setupCategories()
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func setupCategories() {
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION", title: "Stop Adhan", options: [])
        let category = UNNotificationCategory(identifier: "PRAYER_CATEGORY", actions: [stopAction], intentIdentifiers: [], options: [.customDismissAction])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert]) { granted, error in
            if granted {
                print("✅ Notification access granted")
                self.checkBackgroundRefreshStatus()
            } else if let error = error {
                print("❌ Notification access error: \(error)")
            }
        }
    }
    
    private func checkBackgroundRefreshStatus() {
        DispatchQueue.main.async {
            let status = UIApplication.shared.backgroundRefreshStatus
            if status != .available {
                self.showBackgroundRefreshAlert()
            }
        }
    }
    
    private func showBackgroundRefreshAlert() {
        let title = NSLocalizedString("background_refresh_alert_title", comment: "")
        let message = NSLocalizedString("background_refresh_alert_message", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("background_refresh_alert_settings", comment: ""), style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("background_refresh_alert_cancel", comment: ""), style: .cancel))
        
        // Present on top root view controller
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true)
        }
    }
    
    public func schedulePrayerNotifications(for date: Date, times: [String: String], reminders: [String: PrayerReminderType]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateKey = DateFormatter()
        dateKey.dateFormat = "yyyy-MM-dd"
        let dateStr = dateKey.string(from: date)
        
        for (prayer, time) in times {
            let prayerKey = prayer.lowercased()
            let specificKey = "\(dateStr)_\(prayerKey)"
            
            let reminderType = reminders[specificKey] ?? reminders[prayerKey] ?? .silent
            
            if reminderType == .silent { continue }
            
            guard let prayerDate = formatter.date(from: "\(dateStr) \(time)") else { continue }
            if prayerDate < Date() { continue }
            
            // 1. Pre-prayer notification (5 mins before)
            schedulePrePrayer(prayer: prayer, date: prayerDate.addingTimeInterval(-300), dateStr: dateStr)
            
            // 2. Main prayer notification
            scheduleMainPrayer(prayer: prayer, date: prayerDate, type: reminderType, dateStr: dateStr)
        }
    }
    
    public func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func schedulePrePrayer(prayer: String, date: Date, dateStr: String) {
        if date < Date() { return }
        
        let content = UNMutableNotificationContent()
        let localizedName = NSLocalizedString("home_prayer_\(prayer.lowercased())", comment: "")
        content.title = NSLocalizedString("prayer_pre_notification_title", comment: "Incoming Prayer")
        let bodyFormat = NSLocalizedString("prayer_status_minutes_away", comment: "")
        content.body = String(format: bodyFormat, 5, localizedName)
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "PRE_\(dateStr)_\(prayer)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleMainPrayer(prayer: String, date: Date, type: PrayerReminderType, dateStr: String) {
        if date < Date() { return }
        
        let content = UNMutableNotificationContent()
        let localizedName = NSLocalizedString("home_prayer_\(prayer.lowercased())", comment: "")
        content.title = String(format: NSLocalizedString("prayer_status_entering", comment: ""), localizedName)
        content.body = NSLocalizedString("prayer_notification_body", comment: "It is now time for prayer.")
        content.categoryIdentifier = "PRAYER_CATEGORY"
        
        // Use custom adhan sound if type is adhan
        if type == .adhan {
            let soundName = prayer.lowercased() == "fajr" ? "adhan_fajr.mp3" : "adhan.mp3"
            // Critical sound bypasses silent/DND
            content.sound = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName(rawValue: "Adhan/\(soundName)"), withAudioVolume: 1.0)
        } else if type == .alarm {
            content.sound = .defaultCritical
        } else {
            content.sound = .default
        }
        
        content.userInfo = ["prayer": prayer, "type": type.rawValue]
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "MAIN_\(dateStr)_\(prayer)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let prayerName = userInfo["prayer"] as? String
        
        print("🔔 Notification will present in foreground: \(notification.request.identifier)")
        
        if let prayerType = userInfo["type"] as? String, prayerType == "adhan" {
            // Play full adhan in foreground
            AdhanPlayerService.shared.playAdhan(prayerName: prayerName)
            // Suppress notification sound in foreground as we play it via AdhanPlayerService
            // Use banner and list to show the notification while app is open
            completionHandler([.banner, .list, .badge])
        } else {
            completionHandler([.banner, .list, .badge, .sound])
        }
    }

    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle "Stop Adhan" action or dismissal
        if response.actionIdentifier == "STOP_ACTION" || response.actionIdentifier == UNNotificationDismissActionIdentifier {
            AdhanPlayerService.shared.stop()
            // Remove the notification to stop the system-managed notification sound
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
            completionHandler()
            return
        }
        
        let userInfo = response.notification.request.content.userInfo
        let prayerName = userInfo["prayer"] as? String
        
        if let feature = userInfo["feature"] as? String, feature == "deenmode" {
            NotificationCenter.default.post(name: NSNotification.Name("HIRA_DEEP_LINK"), object: "deenmode")
        }
        
        if let prayerType = userInfo["type"] as? String, prayerType == "adhan" {
            // Start/resume full adhan player session
            AdhanPlayerService.shared.playAdhan(prayerName: prayerName)
        }
        completionHandler()
    }
}
