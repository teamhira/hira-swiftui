//
//  StartJourneyView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct StartJourneyView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    @State private var viewModel = StartJourneyViewModel()
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content Switcher
                Group {
                    switch viewModel.currentStep {
                    case .phaseSelection:
                        phaseSelectionStep
                    case .emotionalHook:
                        emotionalHookStep
                    case .goalSetting:
                        goalSettingStep
                    case .commitment:
                        commitmentStep
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                Spacer(minLength: 0)
                
                navigationOverlay
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Capsule()
                            .fill(index == stepIndex ? colors.primary : (index < stepIndex ? colors.primary.opacity(0.4) : colors.foreground.opacity(0.1)))
                            .frame(width: index == stepIndex ? 24 : 8, height: 6)
                            .animation(.spring(), value: stepIndex)
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var phaseSelectionStep: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Text(appEnv.language.localizedString("hijrah_start_title"))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("hijrah_start_subtitle"))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HijrahJourneyCard(
                        type: .mualaf,
                        title: appEnv.language.localizedString("hijrah_mualaf_title"),
                        desc: appEnv.language.localizedString("hijrah_mualaf_desc"),
                        icon: "leaf.fill",
                        isSelected: viewModel.selectedType == .mualaf,
                        colors: colors
                    ) { 
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedType = .mualaf 
                        }
                    }
                    
                    HijrahJourneyCard(
                        type: .hijrah,
                        title: appEnv.language.localizedString("hijrah_back_title"),
                        desc: appEnv.language.localizedString("hijrah_back_desc"),
                        icon: "arrow.triangle.2.circlepath",
                        isSelected: viewModel.selectedType == .hijrah,
                        colors: colors
                    ) { 
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedType = .hijrah 
                        }
                    }
                    
                    HijrahJourneyCard(
                        type: .better,
                        title: appEnv.language.localizedString("hijrah_better_title"),
                        desc: appEnv.language.localizedString("hijrah_better_desc"),
                        icon: "hands.sparkles.fill",
                        isSelected: viewModel.selectedType == .better,
                        colors: colors
                    ) { 
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedType = .better 
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12) // Added to prevent shadow/scale clipping
                .padding(.bottom, 24)
            }
        }
    }
    
    private var emotionalHookStep: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                // Background Glow
                Circle()
                    .fill(colors.primary.opacity(0.15))
                    .frame(width: 200, height: 200)
                    .blur(radius: 40)
                
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(colors.primary)
                            .shadow(color: colors.primary.opacity(0.4), radius: 15)
                    )
                    .scaleEffect(1.1)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: true)
            }
            
            VStack(spacing: 16) {
                Text(appEnv.language.localizedString("hijrah_hook_text"))
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colors.foreground)
                    .padding(.horizontal, 30)
                
                Text(appEnv.language.localizedString("hijrah_hook_desc_sub"))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
                    .lineSpacing(6)
            }
            
            Spacer()
        }
    }
    
    private var goalSettingStep: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Text(appEnv.language.localizedString("hijrah_goal_title"))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("hijrah_goal_subtitle"))
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(viewModel.availableGoals, id: \.self) { goalKey in
                        GoalToggleCard(
                            title: appEnv.language.localizedString(goalKey),
                            isSelected: viewModel.selectedGoals.contains(appEnv.language.localizedString(goalKey)),
                            colors: colors
                        ) {
                            viewModel.toggleGoal(appEnv.language.localizedString(goalKey))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12) // Added to prevent shadow/scale clipping
                .padding(.bottom, 24)
            }
        }
    }
    
    private var commitmentStep: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(colors.secondary.opacity(0.1))
                    .frame(width: 160, height: 160)
                
                VStack(spacing: 4) {
                    Image(systemName: "hourglass")
                        .font(.title)
                        .padding(.bottom, 4)
                    Text("10-15")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    Text(appEnv.language.localizedString("hijrah_commitment_unit"))
                        .font(.subheadline.bold())
                        .opacity(0.7)
                }
                .foregroundColor(colors.secondary)
            }
            
            VStack(spacing: 16) {
                Text(appEnv.language.localizedString("hijrah_commitment_text"))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colors.foreground)
                    .padding(.horizontal, 40)
                
                Text(appEnv.language.localizedString("hijrah_commitment_sub"))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 50)
            }
            
            Spacer()
        }
    }
    
    private var navigationOverlay: some View {
        VStack(spacing: 12) {
            Button(action: { 
                if viewModel.currentStep == .commitment {
                    if let state = viewModel.completeOnboarding() {
                        router.navigate(to: .hijrahDashboard(state))
                    }
                } else {
                    viewModel.nextStep() 
                }
            }) {
                HStack {
                    Text(continueButtonText)
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                        .font(.subheadline.bold())
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(canContinue ? colors.primary : colors.foreground.opacity(0.2))
                .cornerRadius(16)
                .shadow(color: canContinue ? colors.primary.opacity(0.2) : .clear, radius: 8, y: 4)
            }
            .disabled(!canContinue)
            
            if stepIndex > 0 {
                Button(action: { viewModel.previousStep() }) {
                    Text(appEnv.language.localizedString("hijrah_button_back"))
                        .font(.subheadline.bold())
                        .foregroundColor(colors.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
    
    // MARK: - Logic Helpers
    private var navigationTitle: String {
        switch viewModel.currentStep {
        case .phaseSelection: return "Mulai Perjalanan"
        case .emotionalHook: return "Niat Suci"
        case .goalSetting: return "Tujuan Utama"
        case .commitment: return "Komitmen Diri"
        }
    }
    
    private var stepIndex: Int {
        switch viewModel.currentStep {
        case .phaseSelection: return 0
        case .emotionalHook: return 1
        case .goalSetting: return 2
        case .commitment: return 3
        }
    }
    
    private var canContinue: Bool {
        switch viewModel.currentStep {
        case .phaseSelection: return viewModel.selectedType != nil
        case .emotionalHook: return true
        case .goalSetting: return !viewModel.selectedGoals.isEmpty
        case .commitment: return true
        }
    }
    
    private var continueButtonText: String {
        switch viewModel.currentStep {
        case .phaseSelection, .emotionalHook, .goalSetting:
            return appEnv.language.localizedString("hijrah_hook_button")
        case .commitment:
            return appEnv.language.localizedString("hijrah_commitment_button")
        }
    }
}

#Preview {
    StartJourneyView()
        .environment(AppRouter())
        .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
}
