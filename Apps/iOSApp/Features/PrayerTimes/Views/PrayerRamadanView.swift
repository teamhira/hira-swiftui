//
//  PrayerRamadanView.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

struct PrayerRamadanView: View {
    let ramadan: RamadanTimetableResponse
    let colors: ThemeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Ramadan Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "moon.stars.fill")
                        .foregroundColor(colors.primary)
                    let format = NSLocalizedString("prayer_ramadan_hijri_format", comment: "")
                    Text(String(format: format, ramadan.hijriYear))
                        .font(TextStyle.title2)
                        .fontWeight(.black)
                }
                Text(NSLocalizedString("prayer_ramadan_subtitle", comment: ""))
                    .font(TextStyle.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            
            // Timeline List
            VStack(spacing: 16) {
                ForEach(ramadan.days.prefix(15), id: \.date) { day in
                    ramadanDayRow(for: day)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func ramadanDayRow(for day: RamadanTimetableDayResponse) -> some View {
        HStack(spacing: 16) {
            // Date Info
            VStack(alignment: .leading, spacing: 4) {
                Text(day.hijriDate.replacingOccurrences(of: " Ramadan 1447", with: ""))
                    .font(TextStyle.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(colors.primary)
                Text(day.dayName)
                    .font(TextStyle.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            .frame(width: 50)
            
            // Times
            HStack(spacing: 12) {
                ramadanTimeCard(title: NSLocalizedString("home_prayer_imsak", comment: ""), time: day.suhoorEnds, icon: "moon.haze.fill")
                ramadanTimeCard(title: NSLocalizedString("home_prayer_maghrib", comment: ""), time: day.iftar, icon: "sun.sunset.fill")
            }
        }
        .padding(16)
        .background(colors.background)
        .cornerRadius(24)
        .hiraCleanCard(colors: colors)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isToday(day.date) ? colors.primary.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
    
    private func ramadanTimeCard(title: String, time: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(TextStyle.caption2)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(.secondary)
            
            Text(time)
                .font(TextStyle.headline)
                .fontWeight(.black)
                .foregroundColor(colors.foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func isToday(_ dateStr: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        return dateStr == today
    }
}
