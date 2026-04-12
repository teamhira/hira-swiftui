//
//  HijrahView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct HijrahView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var viewModel: HijrahViewModel
    @State private var showingEditOnboarding = false
    @State private var showingHistory = false
    @State private var showingAchievementList = false
    @State private var selectedAchievement: Achievement? = nil
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    init(state: JourneyState) {
        _viewModel = State(initialValue: HijrahViewModel(state: state))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // MARK: 0. Date & Prayer Header
                    hijrahHeaderView
                    
                    // MARK: 1. Journey Profile Status
                    JourneyProfileCard(
                        typeName: viewModel.journeyTypeName,
                        goals: viewModel.goals,
                        colors: colors
                    )
                    
                    // MARK: 2. Level & Progress
                    LevelProgressCard(
                        level: viewModel.state.level,
                        levelName: viewModel.currentLevelName,
                        xp: viewModel.state.xp,
                        streak: viewModel.state.streak,
                        progress: viewModel.levelProgress,
                        colors: colors
                    )
                    
                    // MARK: 3. Achievements
                    achievementSection
                    
                    // MARK: 4. Daily Missions (Step-by-Step)
                    missionListSection(
                        title: appEnv.language.localizedString("hijrah_dash_today_mission"),
                        missions: viewModel.dailyMissions
                    )
                    
                    // MARK: 5. Weekly Missions
                    missionListSection(
                        title: appEnv.language.localizedString("hijrah_dash_weekly_mission"),
                        missions: viewModel.weeklyMissions
                    )
                    
                    // MARK: 6. Recommendations
                    recommendationsSection
                    
                    // MARK: 7. Encouragement
                    encouragementCard
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
            
            // Chatbot FAB
            Button(action: { router.navigate(to: .chatbot) }) {
                ZStack {
                    Circle()
                        .fill(colors.primary)
                        .frame(width: 60, height: 60)
                        .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { router.popToRoot() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text(appEnv.language.localizedString("explore_title"))
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(colors.primary)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    // History Button
                    Button(action: { showingHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(colors.foreground.opacity(0.5))
                    }
                    
                    // Edit Button
                    Button(action: { showingEditOnboarding = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(colors.foreground.opacity(0.5))
                            .font(.system(size: 18))
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditOnboarding) {
            EditJourneyView(
                currentType: viewModel.state.type,
                selectedGoals: viewModel.goals,
                colors: colors,
                onSave: { newType, newGoals in
                    viewModel.updateJourney(type: newType, selectedGoals: newGoals)
                }
            )
            .environment(\.appEnvironment, appEnv)
        }
        .sheet(isPresented: $showingHistory) {
            JourneyHistoryView(state: viewModel.state, colors: colors)
                .environment(\.appEnvironment, appEnv)
        }
        .sheet(item: $selectedAchievement) { achievement in
             AchievementDetailSheet(achievement: achievement, colors: colors, appEnv: appEnv)
                 .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingAchievementList) {
            AchievementListView(achievements: viewModel.achievements, colors: colors)
                .environment(\.appEnvironment, appEnv)
        }
    }
    
    private var hijrahHeaderView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.hijriDate)
                        .font(.headline.bold())
                        .foregroundColor(colors.primary)
                    Text(viewModel.gregorianDate)
                        .font(.caption)
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
                Spacer()
                
                HStack(spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(viewModel.currentPrayerName)
                            .font(.caption2.bold())
                            .foregroundColor(colors.foreground.opacity(0.4))
                        Text(viewModel.currentPrayerTime)
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                    }
                    Circle()
                        .fill(colors.primary.opacity(0.1))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(colors.primary)
                        )
                }
            }
            .padding(16)
            .background(colors.background)
            .cornerRadius(24)
            .shadow(color: colors.foreground.opacity(0.04), radius: 10, x: 0, y: 5)
            
            // Minimal prayer dots
            HStack(spacing: 12) {
                ForEach(viewModel.prayerTimes, id: \.name) { prayer in
                    VStack(spacing: 4) {
                        Text(prayer.name)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(prayer.active ? colors.primary : colors.foreground.opacity(0.3))
                        Circle()
                            .fill(prayer.active ? colors.primary : colors.foreground.opacity(0.1))
                            .frame(width: 4, height: 4)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 16)
    }
    
    private var achievementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(appEnv.language.localizedString("hijrah_dash_achievements"))
                    .font(.headline)
                Spacer()
                Button(action: { showingAchievementList = true }) {
                    Text(appEnv.language.localizedString("hijrah_history_view_all"))
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.achievements) { ach in
                        Button(action: { selectedAchievement = ach }) {
                            AchievementBadge(icon: ach.icon, label: ach.title, colors: colors)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, -24)
        }
    }
    
    private func missionListSection(title: String, missions: [Mission]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(colors.foreground)
            
            VStack(spacing: 12) {
                ForEach(missions) { mission in
                    MissionCard(
                        mission: mission,
                        isLocked: viewModel.isLocked(mission, in: missions),
                        colors: colors,
                        viewModel: viewModel
                    )
                }
            }
        }
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(appEnv.language.localizedString("hijrah_dash_suggestions"))
                .font(.headline)
                .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.suggestions, id: \.self) { suggestion in
                        Button(action: { router.navigate(to: .suggestionDetail(suggestion)) }) {
                            VStack(alignment: .leading, spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(colors.primary.opacity(0.12))
                                        .frame(width: 48, height: 48)
                                    Image(systemName: suggestion.icon)
                                        .font(.title3)
                                        .foregroundColor(colors.primary)
                                }
                                
                                Text(suggestion.title)
                                    .font(.subheadline.bold())
                                    .foregroundColor(colors.foreground)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 40, alignment: .topLeading)
                            }
                            .padding(20)
                            .frame(width: 160, height: 150, alignment: .topLeading)
                            .hiraCleanCard(colors: colors, radius: 28)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
    
    private var encouragementCard: some View {
        Text(appEnv.language.localizedString("hijrah_dash_encouragement"))
             .font(.subheadline)
             .multilineTextAlignment(.center)
             .foregroundColor(colors.foreground.opacity(0.7))
             .padding(24)
             .frame(maxWidth: .infinity)
             .background(colors.primary.opacity(0.05))
             .cornerRadius(20)
    }
}
#Preview {
    NavigationStack {
        HijrahView(state: JourneyState(type: .hijrah))
            .environment(AppRouter())
            .environment(AppState())
    }
}
