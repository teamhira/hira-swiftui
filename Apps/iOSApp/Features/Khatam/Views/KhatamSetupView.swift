//
//  KhatamSetupView.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct KhatamSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    let viewModel: KhatamViewModel
    let colors: ThemeModel
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var targetDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    
    // Starting point
    @State private var fromSurah: Int = 1
    @State private var fromAyah: Int = 1
    
    private var selectedSurah: Surah? {
        viewModel.surahs.first(where: { $0.number == fromSurah })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // MARK: - Goal Title
                        sectionCard(
                            title: appEnv.language.localizedString("khatam_details_header"),
                            icon: "pencil.line"
                        ) {
                            TextField(appEnv.language.localizedString("khatam_goal_title_placeholder"), text: $title)
                                .padding()
                                .background(colors.background)
                                .cornerRadius(AppRadius.sm)
                                .foregroundColor(colors.foreground)
                        }
                        
                        // MARK: - Timeframe
                        sectionCard(
                            title: appEnv.language.localizedString("khatam_completion_goal_header"),
                            icon: "calendar"
                        ) {
                            VStack(spacing: AppSpacing.md) {
                                DatePicker(appEnv.language.localizedString("khatam_start_date_label"), selection: $startDate, displayedComponents: .date)
                                    .tint(colors.primary)
                                
                                Divider()
                                
                                DatePicker(appEnv.language.localizedString("khatam_target_date_label"), selection: $targetDate, in: startDate..., displayedComponents: .date)
                                    .tint(colors.primary)
                            }
                        }
                        
                        // MARK: - Starting Point
                        sectionCard(
                            title: appEnv.language.localizedString("khatam_setup_starting_point_header"),
                            icon: "play.circle.fill"
                        ) {
                            VStack(spacing: AppSpacing.md) {
                                customPicker(
                                    label: appEnv.language.localizedString("khatam_from_surah"),
                                    selection: $fromSurah,
                                    options: viewModel.surahs
                                )
                                
                                customAyahInput(
                                    label: appEnv.language.localizedString("khatam_from_ayah"),
                                    value: $fromAyah,
                                    maxAyah: selectedSurah?.versesCount ?? 286
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(appEnv.language.localizedString("khatam_new_goal_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(appEnv.language.localizedString("common_cancel")) { dismiss() }
                        .foregroundColor(colors.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(appEnv.language.localizedString("onboarding_button_start")) {
                        let finalTitle = title.isEmpty ? appEnv.language.localizedString("home_feature_khatam") : title
                        viewModel.createGoal(
                            title: finalTitle, 
                            startDate: startDate, 
                            targetDate: targetDate,
                            startSurah: fromSurah,
                            startAyah: fromAyah
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(colors.primary)
                }
            }
        }
    }
    
    // MARK: - Components
    
    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(colors.primary)
                Text(title)
                    .font(TextStyle.headline)
                    .foregroundColor(colors.foreground)
            }
            
            content()
        }
        .padding()
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)

    }
    
    private func customPicker(label: String, selection: Binding<Int>, options: [Surah]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(TextStyle.caption)
                .foregroundColor(colors.foreground.opacity(0.6))
            
            Picker(label, selection: selection) {
                ForEach(options) { surah in
                    Text("\(surah.number). \(surah.name)").tag(surah.number)
                }
            }
            .pickerStyle(.menu)
            .tint(colors.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colors.background)
            .cornerRadius(AppRadius.sm)
        }
    }
    
    private func customAyahInput(label: String, value: Binding<Int>, maxAyah: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(TextStyle.caption)
                .foregroundColor(colors.foreground.opacity(0.6))
            
            HStack {
                TextField("1", value: value, format: .number)
                    .keyboardType(.numberPad)
                    .padding(10)
                    .background(colors.background)
                    .cornerRadius(AppRadius.sm)
                    .foregroundColor(colors.foreground)
                    .onChange(of: value.wrappedValue) { oldValue, newValue in
                        if newValue < 1 {
                            value.wrappedValue = 1
                        } else if newValue > maxAyah {
                            value.wrappedValue = maxAyah
                        }
                    }
                
                Spacer()
                
                Text(appEnv.language.localizedString("khatam_max_ayah", arguments: [maxAyah]))
                    .font(.caption2)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
        }
    }



}
