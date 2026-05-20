//
//  PrayerWidgetView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
struct PrayerWidgetView: View {
    let colors: ThemeModel
    @Binding var animate: Bool
    @Environment(\.appEnvironment) private var appEnv
    @StateObject private var viewModel = PrayerWidgetViewModel()
    @State private var showInfo: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Header Row: Location, Date & Madhab
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.locationName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    Text(viewModel.dateString)
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
                if !viewModel.madhab.isEmpty {
                    Text(viewModel.madhab)
                        .font(.system(size: 9, weight: .black))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                }
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .foregroundColor(.white)
            
            // Current/Next Section: Compact
            if viewModel.currentStatus != nil {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(appEnv.language.localizedString("home_prayer_countdown_prefix"))
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                        
                        Text(appEnv.language.localizedString("home_prayer_" + (viewModel.nextPrayerName.isEmpty ? "dhuhr" : viewModel.nextPrayerName.lowercased())))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(viewModel.countdownString)
                        .font(.system(size: 24, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
            }
            
            // Tiny Timeline
            HStack(spacing: 0) {
                ForEach([
                    ("IMS", viewModel.prayerTimes?.imsak),
                    ("FAJ", viewModel.prayerTimes?.fajr),
                    ("SUN", viewModel.prayerTimes?.sunrise),
                    ("DHU", viewModel.prayerTimes?.dhuhr),
                    ("ASR", viewModel.prayerTimes?.asr),
                    ("MAG", viewModel.prayerTimes?.maghrib),
                    ("ISH", viewModel.prayerTimes?.isha)
                ], id: \.0) { name, time in
                    let isActive = viewModel.activePrayerName?.prefix(3).uppercased() == name.uppercased() ||
                                  (name == "SUN" && viewModel.activePrayerName?.lowercased() == "sunrise")
                    
                    VStack(spacing: 4) {
                        Text(name)
                            .font(.system(size: 8, weight: .black))
                            .foregroundColor(isActive ? .white : .white.opacity(0.4))
                        Text(time ?? "--:--")
                            .font(.system(size: 10, weight: isActive ? .bold : .medium, design: .rounded))
                            .foregroundColor(isActive ? .white : .white.opacity(0.7))
                        if isActive {
                            Circle().fill(Color.white).frame(width: 3, height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(backgroundView)
        .shadow(color: colors.primary.opacity(0.2), radius: 15, x: 0, y: 8)
        .padding(.horizontal, AppSpacing.lg)
        .scaleEffect(animate ? 1 : 0.98)
        .opacity(animate ? 1 : 0)
        .sheet(isPresented: $showInfo) {
            IslamicInfoView(info: viewModel.islamicInfo, colors: colors)
                .presentationDetents([.medium, .large])
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        ZStack {
            colors.primary
            LinearGradient(
                colors: [colors.secondary.opacity(0.6), .clear],
                startPoint: .bottomTrailing,
                endPoint: .topLeading
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct IslamicInfoView: View {
    let info: UmmahPrayerIslamicInfoEntity?
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let note = info?.note {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "quote.opening")
                                Text(appEnv.language.localizedString("home_prayer_note_title"))
                            }
                            .font(.headline)
                            .foregroundColor(colors.primary)
                            
                            Text(note)
                                .font(.body)
                                .foregroundColor(colors.foreground.opacity(0.8))
                                .padding()
                                .background(colors.primary.opacity(0.05))
                                .cornerRadius(16)
                        }
                    }
                    
                    if let prayerNames = info?.prayerNames {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(appEnv.language.localizedString("home_prayer_description_title"))
                                .font(.headline)
                                .foregroundColor(colors.primary)
                            
                            let order = ["fajr", "dhuhr", "asr", "maghrib", "isha"]
                            let sortedKeys = prayerNames.keys.sorted { (key1, key2) -> Bool in
                                let index1 = order.firstIndex(of: key1.lowercased()) ?? 99
                                let index2 = order.firstIndex(of: key2.lowercased()) ?? 99
                                return index1 < index2
                            }
                            
                            ForEach(sortedKeys, id: \.self) { key in
                                if let value = prayerNames[key] {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(appEnv.language.localizedString("home_prayer_" + key.lowercased()))
                                            .font(.subheadline.bold())
                                            .foregroundColor(colors.foreground)
                                        Text(value)
                                            .font(.callout)
                                            .foregroundColor(colors.foreground.opacity(0.7))
                                    }
                                    .padding(.bottom, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    if key != sortedKeys.last {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    
                    if info == nil {
                        ContentUnavailableView(
                            "No Info Available",
                            systemImage: "info.circle",
                            description: Text("Islamic information is currently unavailable for this calculation method.")
                        )
                    }
                }
                .padding()
            }
            .navigationTitle(appEnv.language.localizedString("home_prayer_islamic_info"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(appEnv.language.localizedString("common_close")) {
                        dismiss()
                    }
                }
            }
        }
    }
}
