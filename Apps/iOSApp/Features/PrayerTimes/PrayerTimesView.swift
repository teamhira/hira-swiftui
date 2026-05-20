//
//  PrayerTimesView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
public struct PrayerTimesView: View {
    @State private var viewModel = PrayerTimesViewModel()
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    @State private var selectedTab: Int = 0 // 0: Today, 1: Month
    @State private var showSettings: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                PrayerHeaderView(status: viewModel.prayerResponse?.currentStatus, countdownOverride: viewModel.countdownString, nextPrayerNameOverride: viewModel.nextPrayerName, colors: colors)
                    .padding(.bottom, 24)
                
                // MARK: - Navigation Tabs (Native)
                Picker("", selection: $selectedTab) {
                    Text(NSLocalizedString("prayer_tab_today", comment: "")).tag(0)
                    Text(NSLocalizedString("prayer_tab_monthly", comment: "")).tag(1)
                    if viewModel.isRamadan {
                        Text(NSLocalizedString("prayer_tab_ramadan", comment: "")).tag(2)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // MARK: - Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        switch selectedTab {
                        case 0: PrayerTodayView(viewModel: viewModel, colors: colors)
                        case 1: PrayerMonthlyView(viewModel: viewModel, colors: colors)
                        case 2:
                            if let ramadan = viewModel.ramadanTimetable {
                                PrayerRamadanView(ramadan: ramadan, colors: colors)
                            }
                        default: EmptyView()
                        }
                    }
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
        }
        .task {
            viewModel.fetchAllData()
        }
        .sheet(isPresented: $showSettings) {
            PrayerSettingsView(viewModel: viewModel) {
                showSettings = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
#Preview {
    NavigationStack {
        PrayerTimesView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
