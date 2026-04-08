//
//  TasbihView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

public struct TasbihView: View {
    // MARK: - Environment
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    // MARK: - State
    @State private var viewModel = TasbihViewModel()
    @State private var showingTargetAlert = false
    @State private var targetInput: String = ""
    @State private var showingDhikrSheet = false
    @State private var showingSequenceSheet = false
    
    // MARK: - Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(mission: Mission? = nil) {
        let vm = TasbihViewModel()
        if let mission {
            vm.setupMission(mission)
        }
        _viewModel = State(initialValue: vm)
    }
    
    public var body: some View {
        ZStack {
            // Background
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Reduced top allowance
                Spacer(minLength: 20)
                
                // MARK: 1. Main Display Content
                mainDisplaySection
                
                Spacer(minLength: 10)
                
                // MARK: 2. Interactive Selection Layer
                TasbihStylePicker(
                    selectedStyle: $viewModel.selectedStyle,
                    onDhikrTap: { showingDhikrSheet = true },
                    onHaptic: { triggerHaptic($0) }
                )
                .padding(.bottom, 20) // Moderate lift to keep within bounds
            }
        }
        .toolbar { toolbarContent }
        .alert(appEnv.language.localizedString("tasbih_alert_target_title"), isPresented: $showingTargetAlert) { targetAlertActions } message: { targetAlertMessage }
        // MARK: Sheets
        .sheet(isPresented: $showingDhikrSheet, onDismiss: { viewModel.syncSequence() }) {
            DhikrSelectionView(selectedDhikrIds: $viewModel.selectedDhikrIds)
        }
        .sheet(isPresented: $showingSequenceSheet) {
            DhikrSequenceView(sequence: $viewModel.dhikrSequence)
        }
        .sheet(isPresented: Binding(
            get: { viewModel.isSessionCompleted },
            set: { _ in viewModel.isSessionCompleted = false }
        )) {
            TasbihCompletionView(
                onRestart: { viewModel.reset() },
                onClose: { viewModel.isSessionCompleted = false }
            )
        }
        .sheet(isPresented: Binding(
            get: { viewModel.isMissionCompleted },
            set: { _ in viewModel.isMissionCompleted = false }
        )) {
            if let mission = viewModel.currentMission {
                TasbihMissionCompletionView(mission: mission, colors: colors) {
                    router.popToRoot()
                }
            }
        }
    }
}

// MARK: - Subviews
extension TasbihView {
    
    private var mainDisplaySection: some View {
        VStack(spacing: 12) { // Tighter global spacing
            // Current Dhikr Identity
            VStack {
                if let current = viewModel.currentDhikr {
                    VStack(spacing: 4) {
                        Text(current.arabic)
                            .font(.title3.bold()) // Slightly smaller title
                            .foregroundColor(colors.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Text(current.transliteration)
                            .font(.caption) // Smaller transliteration
                            .foregroundColor(colors.foreground.opacity(0.4))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .transition(.opacity.combined(with: .scale(0.95)))
                } else {
                    Spacer().frame(height: 40) 
                }
            }
            .frame(minHeight: 60)
            
            // Counter Logic
            TasbihCounter(
                count: viewModel.count,
                target: viewModel.target,
                loop: viewModel.loop
            )
            .scaleEffect(0.9) // Slightly scale down to save vertical space
            .onTapGesture {
                targetInput = "\(viewModel.target)"
                showingTargetAlert = true
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(appEnv.language.localizedString("tasbih_accessibility_counter"))
            .accessibilityValue("\(viewModel.count)")
            .accessibilityHint(appEnv.language.localizedString("tasbih_accessibility_counter_hint"))
            
            // Interactive Beads Canvas
            TasbihBeadCanvas(
                style: viewModel.selectedStyle,
                onIncrement: { handleSwipeAction(isLeft: true) },
                onDecrement: { handleSwipeAction(isLeft: false) }
            )
            .frame(height: 180) // Reduced height to significantly lift the card
            .accessibilityLabel(appEnv.language.localizedString("tasbih_accessibility_beads"))
            .accessibilityHint(appEnv.language.localizedString("tasbih_accessibility_beads_hint"))
            
            Text(appEnv.language.localizedString("tasbih_hint"))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.25))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.currentDhikr?.transliteration ?? "Tasbih")
    }
}

// MARK: - Actions & Logic
extension TasbihView {
    
    private func handleSwipeAction(isLeft: Bool) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            viewModel.handleSwipe(isLeft: isLeft)
            if viewModel.isSoundEnabled { triggerHaptic(.medium) }
        }
    }
    
    private func resetWithAnimation() {
        withAnimation(.spring()) { viewModel.reset() }
        triggerHaptic(.light)
    }
    
    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

// MARK: - UI Components (Toolbar & Alert)
extension TasbihView {
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(appEnv.language.localizedString("tasbih_title"))
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation {
                        viewModel.isSoundEnabled.toggle()
                        triggerHaptic(.soft)
                    }
                }) {
                    Image(systemName: viewModel.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .foregroundColor(colors.primary)
                }
                
                if !viewModel.selectedDhikrIds.isEmpty {
                    Button(action: {
                        viewModel.syncSequence()
                        showingSequenceSheet = true
                    }) {
                        Image(systemName: "list.bullet.indent")
                            .foregroundColor(colors.primary)
                    }
                }
                
                Button(action: {
                    resetWithAnimation()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(colors.primary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var targetAlertActions: some View {
        TextField(appEnv.language.localizedString("tasbih_alert_target_placeholder"), text: $targetInput)
            .keyboardType(.numberPad)
        
        Button(appEnv.language.localizedString("accessibility_button_cancel"), role: .cancel) { }
        Button(appEnv.language.localizedString("accessibility_button_save")) {
            if let newTarget = Int(targetInput), newTarget > 0 {
                withAnimation { viewModel.target = newTarget }
            }
        }
    }
    
    private var targetAlertMessage: some View {
        Text(appEnv.language.localizedString("tasbih_custom_target_desc"))
    }
}

#Preview {
    NavigationStack {
        TasbihView()
            .environment(AppRouter())
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
