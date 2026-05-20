//
//  PrayerTimelineView.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

struct PrayerTimelineView: View {
    let times: [String: String]
    let nextPrayer: String?
    let colors: ThemeModel
    let date: String?
    let getReminder: (String, String?) -> PrayerReminderType
    let onToggle: (String, String?) -> Void
    
    init(
        times: [String: String],
        nextPrayer: String? = nil,
        colors: ThemeModel,
        date: String? = nil,
        getReminder: @escaping (String, String?) -> PrayerReminderType,
        onToggle: @escaping (String, String?) -> Void
    ) {
        self.times = times
        self.nextPrayer = nextPrayer
        self.colors = colors
        self.date = date
        self.getReminder = getReminder
        self.onToggle = onToggle
    }
    
    var body: some View {
        let order = ["imsak", "fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha"]
        let past = isPastDate()
        
        VStack(spacing: 12) {
            ForEach(order, id: \.self) { key in
                if let time = times[key] {
                    PrayerTimeRow(
                        name: key.capitalized,
                        time: time,
                        isNext: nextPrayer?.lowercased() == key,
                        reminderType: getReminder(key, date),
                        colors: colors,
                        isDisabled: past,
                        onToggle: { onToggle(key, date) }
                    )
                }
            }
        }
    }
    
    private func isPastDate() -> Bool {
        guard let dateStr = date else { return false }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let d = formatter.date(from: dateStr) {
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            return d < startOfToday
        }
        return false
    }
}
