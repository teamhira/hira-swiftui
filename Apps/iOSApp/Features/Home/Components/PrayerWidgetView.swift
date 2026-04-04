//
//  PrayerWidgetView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct PrayerWidgetView: View {
    let colors: ThemeModel
    @Binding var animate: Bool
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("03 April 2026")
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.7))
                    Text(appEnv.language.localizedString("home_prayer_title"))
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(.white)
                Text(appEnv.language.localizedString("home_location_jakarta"))
                    .font(.caption.bold())
                    .foregroundColor(.white)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(appEnv.language.localizedString("home_accessibility_prayer_card"))
            
            HStack(spacing: 0) {
                prayerTimeItem(name: appEnv.language.localizedString("home_prayer_fajr"), time: "04:36", active: false)
                prayerTimeItem(name: appEnv.language.localizedString("home_prayer_dhuhr"), time: "11:58", active: true)
                prayerTimeItem(name: appEnv.language.localizedString("home_prayer_asr"), time: "15:12", active: false)
                prayerTimeItem(name: appEnv.language.localizedString("home_prayer_maghrib"), time: "18:02", active: false)
                prayerTimeItem(name: appEnv.language.localizedString("home_prayer_isha"), time: "19:11", active: false)
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(colors: [colors.primary, colors.secondary], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .shadow(color: colors.primary.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal, AppSpacing.lg)
        .scaleEffect(animate ? 1 : 0.95)
        .opacity(animate ? 1 : 0)
    }
    
    private func prayerTimeItem(name: String, time: String, active: Bool) -> some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(active ? .white : .white.opacity(0.5))
            
            Text(time)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(active ? Color.white.opacity(0.2) : Color.clear)
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel("\(name), \(time)")
        .accessibilityAddTraits(active ? .isSelected : [])
    }
}
