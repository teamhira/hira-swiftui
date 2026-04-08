//
//  MissionDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct MissionDetailView: View {
    let mission: Mission
    let viewModel: HijrahViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Mission States
    @State private var selectedOptionId: String?
    @State private var isAnswerChecked = false
    @State private var timerRemainingSeconds: Int = 0
    @State private var isTimerRunning = false
    @State private var timer: Timer? = nil
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        // Title & Metadata
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Text(missionTypeLabel)
                                    .font(.system(size: 10, weight: .black))
                                    .textCase(.uppercase)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(colors.primary.opacity(0.1))
                                    .foregroundColor(colors.primary)
                                    .cornerRadius(6)
                                
                                Text("\(mission.expReward) XP")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(mission.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(colors.foreground)
                            
                            Text(mission.description)
                                .font(.body)
                                .foregroundColor(colors.foreground.opacity(0.6))
                                .lineSpacing(6)
                        }
                        
                        // Main Visual Content (Video/Audio)
                        if mission.type == .video || mission.type == .audio {
                            mediaSection
                        }
                        
                        // Timer Section
                        if mission.type == .timer {
                            timerSection
                        }
                        
                        // Structured Content
                        if let blocks = mission.content {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(blocks, id: \.self) { block in
                                    ContentBlockRow(block: block, colors: colors)
                                }
                            }
                        }
                        
                        // Quiz Section
                        if mission.type == .quiz, let quiz = mission.quiz {
                            quizSection(quiz)
                        }
                        
                        // References Section
                        if let refs = mission.references {
                            referencesSection(refs)
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding(24)
                }
                
                actionBar
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if mission.type == .timer, let mTimer = mission.timer {
                timerRemainingSeconds = mTimer.targetSeconds
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Batal", role: .cancel) { }
            Button("Konfirmasi") {
                viewModel.completeMission(mission)
                router.pop()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Sections
    private var mediaSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Rectangle()
                    .fill(colors.foreground.opacity(0.05))
                    .aspectRatio(16/9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                VStack(spacing: 12) {
                    Image(systemName: mission.type == .video ? "play.circle.fill" : "waveform.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(colors.primary)
                    
                    Text(mission.type == .video ? "Watch Reflection" : "Listen to Murottal")
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(colors.primary.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    private var timerSection: some View {
        VStack(spacing: 20) {
            Text(mission.timer?.label ?? "Fokus & Renungkan")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                Text("\(timerRemainingSeconds / 60):\(String(format: "%02d", timerRemainingSeconds % 60))")
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(colors.primary)
                
                if isTimerRunning {
                    Circle()
                        .fill(colors.primary)
                        .frame(width: 8, height: 8)
                        .opacity(0.6)
                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: true)
                }
            }
            
            Button(action: toggleTimer) {
                Text(isTimerRunning ? "Pause" : (timerRemainingSeconds == 0 ? "Selesai" : "Mulai Fokus"))
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(colors.primary)
                    .clipShape(Capsule())
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(colors.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
    
    private func quizSection(_ quiz: MissionQuiz) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Knowledge Check")
                .font(.headline)
                .foregroundColor(colors.primary)
            
            Text(quiz.question)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colors.foreground)
            
            VStack(spacing: 12) {
                ForEach(quiz.options, id: \.id) { option in
                    Button(action: {
                        if !isAnswerChecked { selectedOptionId = option.id }
                    }) {
                        HStack {
                            Text(option.text)
                                .font(.body.bold())
                            Spacer()
                            
                            if isAnswerChecked {
                                if option.isCorrect {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                } else if selectedOptionId == option.id {
                                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(optionStrokeColor(option), lineWidth: 2)
                                .background(optionBackgroundColor(option).cornerRadius(16))
                        )
                    }
                }
            }
            
            if isAnswerChecked, let explanation = quiz.explanation {
                Text(explanation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(20)
                    .background(colors.foreground.opacity(0.03))
                    .cornerRadius(16)
            }
        }
    }
    
    private func referencesSection(_ refs: [MissionReference]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Panduan Terkait")
                .font(.headline)
            ForEach(refs, id: \.self) { ref in
                ReferenceRow(ref: ref, colors: colors)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { router.pop() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(colors.foreground)
                    .frame(width: 44, height: 44)
                    .background(colors.foreground.opacity(0.05))
                    .clipShape(Circle())
            }
            Spacer()
            Circle()
                .fill(colors.primary.opacity(0.1))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: missionIcon).foregroundColor(colors.primary))
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
    
    private var actionBar: some View {
        VStack {
            Divider().opacity(0.05)
            if mission.isCompleted {
                Text("✅ Selesai")
                    .font(.headline.bold())
                    .foregroundColor(.green)
                    .frame(height: 56)
            } else {
                Button(action: handleAction) {
                    Text(actionButtonTitle)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(canProceed ? colors.primary : colors.foreground.opacity(0.2))
                        .cornerRadius(16)
                }
                .disabled(!canProceed)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .background(colors.background.opacity(0.95))
    }
    
    // MARK: - Logic
    private func toggleTimer() {
        if isTimerRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timerRemainingSeconds > 0 {
                    timerRemainingSeconds -= 1
                } else {
                    toggleTimer()
                }
            }
        }
        withAnimation { isTimerRunning.toggle() }
    }
    
    private var canProceed: Bool {
        if mission.type == .quiz { return isAnswerChecked && (mission.quiz?.options.first(where: { $0.id == selectedOptionId })?.isCorrect ?? false) }
        if mission.type == .timer { return timerRemainingSeconds == 0 }
        if mission.type == .quiz && !isAnswerChecked { return selectedOptionId != nil }
        return true
    }
    
    private var actionButtonTitle: String {
        if mission.type == .quiz && !isAnswerChecked { return "Periksa Jawaban" }
        if mission.type == .timer && timerRemainingSeconds > 0 { return "Fokus Dulu (\(timerRemainingSeconds)s)" }
        return "Selesaikan Misi"
    }
    
    private func handleAction() {
        if mission.type == .quiz && !isAnswerChecked {
            withAnimation { isAnswerChecked = true }
            return
        }
        alertTitle = "Selesaikan Misi?"
        alertMessage = "Lakukan dengan ikhlas karena Allah SWT."
        showingAlert = true
    }
    
    private var missionIcon: String {
        switch mission.type {
        case .simple: return "sparkles"
        case .knowledge: return "book.fill"
        case .tasbih: return "bolt.fill"
        case .quiz: return "checkmark.shield.fill"
        case .video: return "video.fill"
        case .audio: return "headphones"
        case .timer: return "timer"
        }
    }
    
    private var missionTypeLabel: String {
        mission.type.rawValue.capitalized
    }
    
    private func optionStrokeColor(_ option: QuizOption) -> Color {
        if isAnswerChecked {
            if option.isCorrect { return .green }
            if selectedOptionId == option.id { return .red }
        }
        return selectedOptionId == option.id ? colors.primary : colors.foreground.opacity(0.05)
    }
    
    private func optionBackgroundColor(_ option: QuizOption) -> Color {
        if isAnswerChecked {
            if option.isCorrect { return .green.opacity(0.05) }
            if selectedOptionId == option.id { return .red.opacity(0.05) }
        }
        return selectedOptionId == option.id ? colors.primary.opacity(0.05) : Color.clear
    }
}
