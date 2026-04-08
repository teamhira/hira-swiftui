//
//  EditJourneyView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct EditJourneyView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: JourneyType
    @State private var selectedGoals: Set<String>
    @State private var showingResetAlert = false
    
    let colors: ThemeModel
    let onSave: (JourneyType, [String]) -> Void
    
    // Goals matched with onboarding (StartJourneyViewModel)
    private var availableGoals: [String] {
        switch type {
        case .mualaf:
            return ["hijrah_goal_zero", "hijrah_goal_shalat", "hijrah_goal_allah", "hijrah_goal_consistency"]
        case .hijrah:
            return ["hijrah_goal_shalat", "hijrah_goal_allah", "hijrah_goal_consistency", "hijrah_goal_zero"]
        case .better:
            return ["hijrah_goal_shalat", "hijrah_goal_allah", "hijrah_goal_consistency"]
        }
    }
    
    init(currentType: JourneyType, selectedGoals: [String], colors: ThemeModel, onSave: @escaping (JourneyType, [String]) -> Void) {
        _type = State(initialValue: currentType)
        _selectedGoals = State(initialValue: Set(selectedGoals))
        self.colors = colors
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                colors.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Section 1: Journey Type
                        VStack(alignment: .leading, spacing: 20) {
                            sectionHeader(title: "Pilih Jalur Journey", icon: "map.fill")
                            
                            VStack(spacing: 12) {
                                HijrahJourneyCard(
                                    type: .mualaf,
                                    title: appEnv.language.localizedString("hijrah_mualaf_title"),
                                    desc: appEnv.language.localizedString("hijrah_mualaf_desc"),
                                    icon: "leaf.fill",
                                    isSelected: type == .mualaf,
                                    colors: colors
                                ) { 
                                    if type != .mualaf {
                                        type = .mualaf
                                        selectedGoals.removeAll()
                                    }
                                }
                                
                                HijrahJourneyCard(
                                    type: .hijrah,
                                    title: appEnv.language.localizedString("hijrah_back_title"),
                                    desc: appEnv.language.localizedString("hijrah_back_desc"),
                                    icon: "arrow.triangle.2.circlepath",
                                    isSelected: type == .hijrah,
                                    colors: colors
                                ) { 
                                    if type != .hijrah {
                                        type = .hijrah
                                        selectedGoals.removeAll()
                                    }
                                }
                                
                                HijrahJourneyCard(
                                    type: .better,
                                    title: appEnv.language.localizedString("hijrah_better_title"),
                                    desc: appEnv.language.localizedString("hijrah_better_desc"),
                                    icon: "hands.sparkles.fill",
                                    isSelected: type == .better,
                                    colors: colors
                                ) { 
                                    if type != .better {
                                        type = .better
                                        selectedGoals.removeAll()
                                    }
                                }
                            }
                        }
                        
                        // Section 2: Goals (Dynamic based on selected Type)
                        VStack(alignment: .leading, spacing: 20) {
                            sectionHeader(title: "Target Fokus Kamu", icon: "target")
                            
                            VStack(spacing: 12) {
                                ForEach(availableGoals, id: \.self) { goalKey in
                                    let goalName = appEnv.language.localizedString(goalKey)
                                    GoalToggleCard(
                                        title: goalName,
                                        isSelected: selectedGoals.contains(goalName),
                                        colors: colors
                                    ) {
                                        if selectedGoals.contains(goalName) {
                                            selectedGoals.remove(goalName)
                                        } else {
                                            selectedGoals.insert(goalName)
                                        }
                                    }
                                }
                            }
                            
                            Text("Pilihan target akan menentukan misi harian yang muncul di dashboard.")
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.4))
                                .padding(.top, 4)
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding(24)
                }
                
                // Floating Action Button
                VStack {
                    Divider().opacity(0.05)
                    Button(action: { showingResetAlert = true }) {
                        Text("Simpan Perubahan")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(colors.primary)
                            .cornerRadius(16)
                            .shadow(color: colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(24)
                }
                .background(colors.background.opacity(0.95))
            }
            .navigationTitle("Pengaturan Journey")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Batal") { dismiss() }
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
            }
            .alert("Simpan Perubahan?", isPresented: $showingResetAlert) {
                Button("Simpan & Reset", role: .destructive) {
                    onSave(type, Array(selectedGoals))
                    dismiss()
                }
                Button("Batal", role: .cancel) { }
            } message: {
                Text("Mengubah jalur journey akan meriset progres level dan misi aktif kamu saat ini. Apakah kamu yakin?")
            }
        }
    }
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.bold())
                .foregroundColor(colors.primary)
            Text(title)
                .font(.headline.bold())
                .foregroundColor(colors.foreground)
        }
    }
}
