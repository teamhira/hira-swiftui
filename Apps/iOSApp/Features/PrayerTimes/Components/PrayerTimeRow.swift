//
//  PrayerTimeRow.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

struct PrayerTimeRow: View {
    let name: String
    let time: String
    let isNext: Bool
    let reminderType: PrayerReminderType
    let colors: ThemeModel
    let isDisabled: Bool // Added
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isNext ? colors.primary.opacity(0.12) : colors.foreground.opacity(0.04))
                    .frame(width: 44, height: 44)
                
                Image(systemName: prayerIcon(for: name))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isNext ? colors.primary : colors.foreground.opacity(0.4))
            }
            
            // Name & Status Info
            VStack(alignment: .leading, spacing: 2) {
                Text(localPrayerName(name))
                    .font(TextStyle.subheadline)
                    .fontWeight(isNext ? .bold : .medium)
                    .foregroundColor(isNext ? colors.foreground : colors.foreground.opacity(0.8))
                    .lineLimit(1)
                
                if isNext {
                    Text(NSLocalizedString("prayer_current_title", comment: ""))
                        .font(.system(size: 9, weight: .black))
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            Spacer(minLength: 4)
            
            // Time & Reminder Actions
            HStack(spacing: 14) {
                Text(time)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(isNext ? colors.primary : colors.foreground)
                    .layoutPriority(1)
                
                // Reminder Control
                Button(action: {
                    if !isDisabled {
                        onToggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: reminderIcon(for: reminderType))
                            .font(.system(size: 11, weight: .bold))
                        
                        if isNext {
                            Text(localReminderType(reminderType))
                                .font(.system(size: 10, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    }
                    .foregroundColor(reminderType == .silent ? colors.foreground.opacity(0.3) : colors.primaryForeground)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(
                        ZStack {
                            if reminderType != .silent {
                                colors.primary
                            } else {
                                colors.foreground.opacity(0.06)
                            }
                        }
                    )
                    .clipShape(Capsule())
                }
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.3 : 1.0)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(isNext ? colors.primary.opacity(0.03) : colors.background)
        .cornerRadius(24)
        .hiraCleanCard(colors: colors)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isNext ? colors.primary.opacity(0.15) : Color.clear, lineWidth: 1)
        )
    }
    
    private func localPrayerName(_ name: String) -> String {
        let key = "home_prayer_\(name.lowercased())"
        let localized = NSLocalizedString(key, comment: "")
        return localized == key ? name : localized
    }
    
    private func localReminderType(_ type: PrayerReminderType) -> String {
        switch type {
        case .adhan: return NSLocalizedString("prayer_reminder_adhan", comment: "")
        case .alarm: return NSLocalizedString("prayer_reminder_alarm", comment: "")
        case .silent: return NSLocalizedString("prayer_reminder_silent", comment: "")
        }
    }
    
    private func prayerIcon(for prayer: String) -> String {
        switch prayer.lowercased() {
        case "imsak": return "moon.haze.fill"
        case "fajr": return "sun.haze.fill"
        case "sunrise": return "sunrise.fill"
        case "dhuhr": return "sun.max.fill"
        case "asr": return "sun.min.fill"
        case "maghrib": return "sunset.fill"
        case "isha": return "moon.stars.fill"
        default: return "clock.fill"
        }
    }
    
    private func reminderIcon(for type: PrayerReminderType) -> String {
        switch type {
        case .adhan: return "building.2.fill"
        case .alarm: return "alarm.fill"
        case .silent: return "bell.slash.fill"
        }
    }
}
