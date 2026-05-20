//
//  AddJournalView.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct AddJournalView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    @Binding var viewModel: JournalViewModel
    var editingEntry: JournalEntry?
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var reference: String = ""
    @State private var selectedMood: JournalMood = .peaceful
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    init(viewModel: Binding<JournalViewModel>, editingEntry: JournalEntry? = nil) {
        self._viewModel = viewModel
        self.editingEntry = editingEntry
        _title = State(initialValue: editingEntry?.title ?? "")
        _content = State(initialValue: editingEntry?.content ?? "")
        _reference = State(initialValue: editingEntry?.reference ?? "")
        _selectedMood = State(initialValue: editingEntry?.mood ?? .peaceful)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // MARK: - Mood Selector
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(appEnv.language.localizedString("journal_label_mood"))
                                .font(TextStyle.caption)
                                .fontWeight(.bold)
                                .foregroundColor(colors.primary)
                                .padding(.leading, 4)
                            
                            HStack(spacing: AppSpacing.md) {
                                ForEach(JournalMood.allCases, id: \.self) { mood in
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            selectedMood = mood
                                        }
                                    }) {
                                        VStack(spacing: 4) {
                                            Text(mood.rawValue)
                                                .font(.system(size: 24))
                                            
                                            Text(appEnv.language.localizedString(mood.titleKey))
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(selectedMood == mood ? colors.primary : colors.foreground.opacity(0.4))
                                            
                                            Circle()
                                                .fill(selectedMood == mood ? colors.primary : Color.clear)
                                                .frame(width: 4, height: 4)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedMood == mood ? colors.primary.opacity(0.1) : colors.card)
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(selectedMood == mood ? colors.primary.opacity(0.5) : Color.clear, lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(appEnv.language.localizedString("journal_label_title"))
                                .font(TextStyle.caption)
                                .fontWeight(.bold)
                                .foregroundColor(colors.primary)
                                .padding(.leading, 4)
                            
                            TextField(appEnv.language.localizedString("journal_title_placeholder"), text: $title)
                                .padding()
                                .background(colors.card)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(colors.primary.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(appEnv.language.localizedString("journal_label_content"))
                                .font(TextStyle.caption)
                                .fontWeight(.bold)
                                .foregroundColor(colors.primary)
                                .padding(.leading, 4)
                            
                            contentEditor()
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(appEnv.language.localizedString("journal_label_reference"))
                                .font(TextStyle.caption)
                                .fontWeight(.bold)
                                .foregroundColor(colors.primary)
                                .padding(.leading, 4)
                            
                            TextField(appEnv.language.localizedString("journal_reference_placeholder"), text: $reference)
                                .padding()
                                .background(colors.card)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(colors.primary.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        Button(action: saveAction) {
                            Text(editingEntry == nil ? appEnv.language.localizedString("common_add") : appEnv.language.localizedString("journal_edit_btn"))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(title.isEmpty || content.isEmpty ? colors.primary.opacity(0.5) : colors.primary)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .disabled(title.isEmpty || content.isEmpty)
                        .padding(.top, AppSpacing.md)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle(appEnv.language.localizedString(editingEntry == nil ? "journal_new_entry_title" : "journal_edit_btn"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(appEnv.language.localizedString("common_cancel")) {
                        dismiss()
                    }
                    .foregroundColor(colors.primary)
                }
            }
        }
    }
    
    @ViewBuilder
    private func contentEditor() -> some View {
        TextEditor(text: $content)
            .frame(minHeight: 180)
            .padding(12)
            .scrollContentBackground(.hidden)
            .background(colors.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colors.primary.opacity(0.1), lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                if content.isEmpty {
                    Text(appEnv.language.localizedString("journal_content_placeholder"))
                        .foregroundColor(colors.foreground.opacity(0.3))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
    }
    
    private func saveAction() {
        if let editing = editingEntry {
            var updated = editing
            updated.title = title
            updated.content = content
            updated.reference = reference.isEmpty ? nil : reference
            updated.mood = selectedMood
            viewModel.updateEntry(updated)
        } else {
            let newEntry = JournalEntry(
                title: title,
                content: content,
                reference: reference.isEmpty ? nil : reference,
                mood: selectedMood
            )
            viewModel.addEntry(newEntry)
        }
        dismiss()
    }
}
