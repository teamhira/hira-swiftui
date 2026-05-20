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
    
    @State private var showDatePicker = false
    @State private var tempMonth = 1
    @State private var tempYear = 1447
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    // MARK: - Calendar Header & Navigation
                    monthNavigationHeader()
                    
                    // MARK: - Hijri Grid
                    if viewModel.isLoading {
                        VStack {
                            ProgressView()
                                .tint(colors.primary)
                                .padding(50)
                            Text(appEnv.language.localizedString("common_loading"))
                                .font(TextStyle.caption)
                                .foregroundColor(colors.foreground.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity)
                        .background(colors.card)
                        .cornerRadius(20)
                    } else {
                        HijriCalendarGrid(days: viewModel.currentMonthDays, colors: colors)
                    }
                    
                    // MARK: - Current Month Significance
                    if let currentMonthInfo = viewModel.monthsInfo.first(where: { $0.id == viewModel.selectedMonth }) {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            sectionHeader(title: "calendar_month_significance", icon: "sparkles")
                            HijriMonthInfoCard(month: currentMonthInfo, colors: colors)
                        }
                    }
                    
                    // MARK: - Upcoming Events
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        sectionHeader(title: "calendar_event_title", icon: "calendar.badge.exclamationmark")
                        
                        let monthEvents = viewModel.events.filter { $0.month == viewModel.selectedMonth }

                        
                        if monthEvents.isEmpty {
                            emptyEventsView()
                        } else {
                            VStack(spacing: AppSpacing.md) {
                                ForEach(monthEvents, id: \.title) { event in
                                    HijriEventRow(event: event, colors: colors)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Islamic Months List Navigation
                    NavigationLink {
                        HijriMonthsListView(months: viewModel.monthsInfo, colors: colors)
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet.indent")
                            Text(appEnv.language.localizedString("calendar_view_all_months"))
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(colors.primary.opacity(0.1))
                        .foregroundColor(colors.primary)
                        .cornerRadius(16)
                    }
                    .padding(.top, AppSpacing.md)
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_calendar"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadData()
        }
        // MARK: - Date Picker Sheet
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                VStack(spacing: AppSpacing.lg) {
                    HStack(spacing: 0) {
                        Picker("Month", selection: $tempMonth) {
                            if viewModel.monthsInfo.isEmpty {
                                Text("Loading...").tag(1)
                            } else {
                                ForEach(viewModel.monthsInfo) { month in
                                    Text(month.name).tag(month.id)
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        
                        Picker("Year", selection: $tempYear) {
                            ForEach(1300...1500, id: \.self) { year in
                                Text("\(year)").tag(year)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                    }
                    .padding(.top, AppSpacing.md)
                    
                    Button(action: {
                        viewModel.jumpTo(month: tempMonth, year: tempYear)
                        showDatePicker = false
                    }) {
                        Text(appEnv.language.localizedString("calendar_jump_to_date"))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationTitle(appEnv.language.localizedString("calendar_jump_to_date"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(appEnv.language.localizedString("common_cancel")) {
                            showDatePicker = false
                        }
                    }
                }
                .presentationDetents([.height(350)])
            }
        }
    }


    
    // MARK: - Helpers
    
    @ViewBuilder
    private func monthNavigationHeader() -> some View {
        HStack {
            Button(action: { viewModel.prevMonth() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                    .padding(12)
                    .background(colors.card)
                    .clipShape(Circle())
                    .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.y, y: AppShadow.xs.y)
            }
            .foregroundColor(colors.primary)
            
            Spacer()
            
            Button(action: { 
                tempMonth = viewModel.selectedMonth
                tempYear = viewModel.selectedYear
                showDatePicker = true 
            }) {
                VStack(spacing: 2) {
                    Text("\(viewModel.selectedYear) AH")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(colors.primary)
                    
                    Text(viewModel.currentMonthName)
                        .font(TextStyle.title3)
                        .fontWeight(.black)
                        .foregroundColor(colors.foreground)
                    
                    Text(viewModel.currentMonthNameArabic)
                        .font(.system(size: 14))
                        .foregroundColor(colors.primary.opacity(0.8))
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button(action: { viewModel.nextMonth() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .padding(12)
                    .background(colors.card)
                    .clipShape(Circle())
                    .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
            }
            .foregroundColor(colors.primary)
        }
    }

    
    @ViewBuilder
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .foregroundColor(colors.primary)
            Text(appEnv.language.localizedString(title))
                .font(TextStyle.headline)
                .foregroundColor(colors.foreground)
        }
        .padding(.horizontal, 4)
    }
    
    @ViewBuilder
    private func emptyEventsView() -> some View {
        HStack {
            Spacer()
            Text(appEnv.language.localizedString("calendar_no_events"))
                .font(TextStyle.caption)
                .foregroundColor(colors.foreground.opacity(0.5))
            Spacer()
        }
        .padding()
        .background(colors.card)
        .cornerRadius(20)
    }
}

#Preview {
    NavigationStack {
        CalendarView()
            .environment(AppState())
    }
}
