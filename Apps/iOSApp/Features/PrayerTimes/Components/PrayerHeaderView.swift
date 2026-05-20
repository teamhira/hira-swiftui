//
//  PrayerHeaderView.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

struct PrayerHeaderView: View {
    let status: PrayerCurrentStatus?
    let countdownOverride: String?
    let nextPrayerNameOverride: String? // Added
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    init(status: PrayerCurrentStatus?, countdownOverride: String? = nil, nextPrayerNameOverride: String? = nil, colors: ThemeModel) {
        self.status = status
        self.countdownOverride = countdownOverride
        self.nextPrayerNameOverride = nextPrayerNameOverride
        self.colors = colors
    }
    
    var body: some View {
        HStack(spacing: 20) {
            if let status = status {
                // Next Prayer Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(appEnv.language.localizedString("home_prayer_countdown_prefix"))
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(colors.primaryForeground.opacity(0.6))
                        .textCase(.uppercase)
                        .tracking(1.0)
                    
                    Text(localPrayerName(nextPrayerNameOverride ?? status.nextPrayer))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primaryForeground)
                }
                
                Spacer()
                
                // Countdown Display
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10, weight: .bold))
                    Text(countdownOverride?.isEmpty == false ? (countdownOverride ?? "") : (status.timeUntilNext ?? "--:--"))
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .foregroundColor(colors.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(colors.primaryForeground)
                .clipShape(Capsule())
            } else {
                ProgressView()
                    .tint(colors.primaryForeground)
                Text(NSLocalizedString("home_prayer_title", comment: "") + "...")
                    .font(.footnote)
                    .foregroundColor(colors.primaryForeground)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 100) // Even slimmer
        .background(
            ZStack {
                LinearGradient(
                    colors: [colors.primary, colors.secondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                // Subtle texture
                Circle()
                    .fill(colors.primaryForeground.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .offset(x: 150, y: 0)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
        .shadow(color: colors.primary.opacity(0.2), radius: 15, x: 0, y: 8)
    }
    
    private func localPrayerName(_ name: String) -> String {
        let key = "home_prayer_\(name.lowercased())"
        let localized = NSLocalizedString(key, comment: "")
        return localized == key ? name.capitalized : localized
    }
    
    private func headerImage(for prayer: String) -> Image {
        switch prayer.lowercased() {
        case "fajr", "isha": return Image(systemName: "moon.stars.fill")
        case "sunrise", "dhuhr": return Image(systemName: "sun.max.fill")
        case "asr", "maghrib": return Image(systemName: "sun.horizon.fill")
        default: return Image(systemName: "building.2.fill")
        }
    }
}
