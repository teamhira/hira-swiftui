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
    
    public init() {}
    
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
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbarContent }
        .alert(appEnv.language.localizedString("tasbih_alert_target_title", defaultValue: "Set Target"), isPresented: $showingTargetAlert) { targetAlertActions } message: { targetAlertMessage }
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
            
            // Interactive Beads Canvas
            TasbihBeadCanvas(
                style: viewModel.selectedStyle,
                onIncrement: { handleSwipeAction(isLeft: true) },
                onDecrement: { handleSwipeAction(isLeft: false) }
            )
            .frame(height: 180) // Reduced height to significantly lift the card
            
            Text(appEnv.language.localizedString("tasbih_hint"))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.25))
        }
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
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { router.pop() }) {
                Image(systemName: "chevron.left")
                    .font(.body.bold())
                    .foregroundColor(colors.primary)
                    .frame(width: 44, height: 44)
                    .background(colors.foreground.opacity(0.03))
                    .clipShape(Circle())
            }
        }
        
        ToolbarItem(placement: .principal) {
            Text(appEnv.language.localizedString("tasbih_title"))
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 8) {
                ToolbarStyledButton(icon: viewModel.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill") {
                    withAnimation {
                        viewModel.isSoundEnabled.toggle()
                        triggerHaptic(.soft)
                    }
                }
                
                if !viewModel.selectedDhikrIds.isEmpty {
                    ToolbarStyledButton(icon: "list.bullet.indent") {
                        viewModel.syncSequence()
                        showingSequenceSheet = true
                    }
                }
                
                ToolbarStyledButton(icon: "arrow.counterclockwise") {
                    resetWithAnimation()
                }
            }
        }
    }
    
    @ViewBuilder
    private var targetAlertActions: some View {
        TextField(appEnv.language.localizedString("tasbih_alert_target_placeholder", defaultValue: "Enter target count"), text: $targetInput)
            .keyboardType(.numberPad)
        
        Button(appEnv.language.localizedString("accessibility_button_cancel", defaultValue: "Cancel"), role: .cancel) { }
        Button(appEnv.language.localizedString("accessibility_button_save", defaultValue: "Save")) {
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
