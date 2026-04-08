//
//  CalendarView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = CalendarViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "home_feature_calendar", icon: "calendar") {
            VStack(spacing: 32) {
                // Calendar Card Placeholder
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.hijriDate)
                                .font(.headline.bold())
                                .foregroundColor(colors.primary)
                            Text(viewModel.gregorianDate)
                                .font(.subheadline)
                                .foregroundColor(colors.foreground)
                        }
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(colors.primary)
                    }
                    
                    // Simple Calendar Month Area
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colors.foreground.opacity(0.04))
                            .frame(height: 240)
                            .overlay {
                                Text(appEnv.language.localizedString("calendar_month_placeholder"))
                                    .font(.caption.bold())
                                    .foregroundColor(colors.primary)
                            }
                    }
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(viewModel.hijriDate), \(viewModel.gregorianDate)")
                
                // Important Dates
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("calendar_event_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.importantDates, id: \.self) { item in
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(colors.primary.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay {
                                        Image(systemName: "star.fill")
                                            .font(.caption)
                                            .foregroundColor(colors.primary)
                                    }
                                
                                Text(item)
                                    .font(.subheadline.bold())
                                    .foregroundColor(colors.foreground)
                                
                                Spacer()
                                
                                Text(appEnv.language.localizedString("calendar_upcoming_label"))
                                    .font(.caption)
                                    .foregroundColor(colors.foreground.opacity(0.4))
                            }
                            .padding(16)
                            .background(colors.background)
                            .hiraCleanCard(colors: colors, radius: 12)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(appEnv.language.localizedString("calendar_accessibility_event_item", arguments: [item, appEnv.language.localizedString("calendar_upcoming_label")]))
                        }
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}
