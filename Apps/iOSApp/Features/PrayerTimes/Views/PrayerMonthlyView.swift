//
//  PrayerMonthlyView.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0)
struct PrayerMonthlyView: View {
    @Bindable var viewModel: PrayerTimesViewModel
    let colors: ThemeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let days = viewModel.monthlyTimetable?.days {
                // Header Info
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.monthlyTimetable?.monthName ?? "") \(String(viewModel.monthlyTimetable?.year ?? 2026))")
                            .font(TextStyle.title3)
                            .foregroundColor(colors.foreground)
                        Text(NSLocalizedString("prayer_monthly_select_date_hint", comment: ""))
                            .font(TextStyle.footnote)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                // Date Selector
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(days, id: \.date) { day in
                                dateCard(for: day)
                                    .id(day.date)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12) // Added to prevent border/shadow clipping
                    }
                    .onChange(of: viewModel.selectedMonthlyDate) { _, newValue in
                        if let date = newValue {
                            withAnimation(.spring()) {
                                proxy.scrollTo(date, anchor: .center)
                            }
                        }
                    }
                    .onAppear {
                        if let date = viewModel.selectedMonthlyDate {
                            proxy.scrollTo(date, anchor: .center)
                        }
                    }
                }
                
                // Selected Day Timeline
                if let selectedDate = viewModel.selectedMonthlyDate,
                   let selectedDay = days.first(where: { $0.date == selectedDate }) {
                    VStack(alignment: .leading, spacing: 20) {
                        let format = NSLocalizedString("prayer_monthly_schedule_format", comment: "")
                        Text(String(format: format, "\(selectedDay.dayName), \(selectedDay.day) \(viewModel.monthlyTimetable?.monthName ?? "")"))
                            .font(TextStyle.headline)
                            .foregroundColor(colors.foreground)
                            .padding(.horizontal, 24)
                        
                        PrayerTimelineView(
                            times: selectedDay.prayerTimes.toMap(),
                            colors: colors,
                            date: selectedDate,
                            getReminder: { viewModel.getReminderType(for: $0, on: $1) },
                            onToggle: { viewModel.toggleReminder(for: $0, on: $1) }
                        )
                        .padding(.horizontal, 24)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            } else {
                loadingTimeline.padding(.horizontal, 24)
            }
        }
    }
    
    private func dateCard(for day: MonthlyTimetableDayResponse) -> some View {
        Button {
            withAnimation(.spring()) {
                viewModel.selectedMonthlyDate = day.date
            }
        } label: {
            VStack(spacing: 8) {
                Text(day.dayName.prefix(3))
                    .font(TextStyle.caption)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.selectedMonthlyDate == day.date ? colors.primaryForeground.opacity(0.8) : .secondary)
                
                Text("\(day.day)")
                    .font(TextStyle.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(viewModel.selectedMonthlyDate == day.date ? colors.primaryForeground : colors.foreground)
            }
            .frame(width: 60, height: 90)
            .background(
                ZStack {
                    if viewModel.selectedMonthlyDate == day.date {
                        colors.primary
                    } else {
                        colors.foreground.opacity(0.05)
                    }
                }
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isToday(day.date) ? colors.primary.opacity(0.5) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
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
    
    private func isToday(_ dateStr: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        return dateStr == today
    }
}
