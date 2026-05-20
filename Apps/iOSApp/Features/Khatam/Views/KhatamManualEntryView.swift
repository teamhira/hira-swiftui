//
//  KhatamManualEntryView.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct KhatamManualEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    let viewModel: KhatamViewModel
    let colors: ThemeModel
    
    // Range state
    @State private var fromSurah: Int = 1
    @State private var fromAyah: Int = 1
    @State private var toSurah: Int = 1
    @State private var toAyah: Int = 1
    @State private var isSaving: Bool = false
    
    private var startSurah: Surah? {
        viewModel.surahs.first(where: { $0.number == fromSurah })
    }
    
    private var endSurah: Surah? {
        viewModel.surahs.first(where: { $0.number == toSurah })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // MARK: - From Card
                        sectionCard(
                            title: appEnv.language.localizedString("khatam_from"),
                            icon: "arrow.right.circle.fill"
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
                                    maxAyah: startSurah?.versesCount ?? 286
                                )
                            }
                        }
                        
                        // MARK: - To Card
                        sectionCard(
                            title: appEnv.language.localizedString("khatam_progress_by_range"),
                            icon: "flag.fill"
                        ) {
                            VStack(spacing: AppSpacing.md) {
                                customPicker(
                                    label: appEnv.language.localizedString("khatam_to_surah"),
                                    selection: $toSurah,
                                    options: viewModel.surahs
                                )
                                
                                customAyahInput(
                                    label: appEnv.language.localizedString("khatam_to_ayah"),
                                    value: $toAyah,
                                    maxAyah: endSurah?.versesCount ?? 286
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(appEnv.language.localizedString("khatam_add_progress"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(appEnv.language.localizedString("common_cancel")) { dismiss() }
                        .foregroundColor(colors.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveRangeProgress()
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text(appEnv.language.localizedString("accessibility_button_save"))
                                .fontWeight(.bold)
                                .foregroundColor(colors.primary)
                        }
                    }
                    .disabled(isSaving || toSurah < fromSurah || (toSurah == fromSurah && toAyah < fromAyah))
                }
            }
            .onAppear {
                if let goal = viewModel.activeGoal {
                    let nextAyah = goal.lastAyah + (goal.logs.isEmpty ? 0 : 1)
                    fromSurah = goal.lastSurah
                    fromAyah = nextAyah

                    
                    // Boundary check
                    let maxAyah = viewModel.getSurahVersesCount(id: fromSurah)
                    if fromAyah > maxAyah {
                        fromSurah = min(114, fromSurah + 1)
                        fromAyah = 1
                    }
                    
                    toSurah = fromSurah
                    toAyah = fromAyah
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

    
    private func saveRangeProgress() {
        isSaving = true
        
        viewModel.addManualRangeProgress(
            fromSurah: fromSurah, fromAyah: fromAyah, toSurah: toSurah, toAyah: toAyah
        ) {
            isSaving = false
            dismiss()
        }
    }
}
