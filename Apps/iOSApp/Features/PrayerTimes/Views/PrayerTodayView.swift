//
//  PrayerTodayView.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0)
struct PrayerTodayView: View {
    let viewModel: PrayerTimesViewModel
    let colors: ThemeModel
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                loadingTimeline
            } else if let times = viewModel.prayerResponse?.prayerTimes.toMap() {
                PrayerTimelineView(
                    times: times,
                    nextPrayer: viewModel.activePrayerName ?? viewModel.prayerResponse?.currentStatus?.nextPrayer,
                    colors: colors,
                    date: nil,
                    getReminder: { viewModel.getReminderType(for: $0, on: $1) },
                    onToggle: { viewModel.toggleReminder(for: $0, on: $1) }
                )
            }
        }
        .padding(.top, 12) // Added to prevent shadow clipping
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    private var loadingTimeline: some View {
        VStack(spacing: 12) {
            ForEach(0..<5, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 24)
                    .fill(colors.foreground.opacity(0.05))
                    .frame(height: 80)
                    .hiraShimmer()
            }
        }
    }
}
