//
//  JournalDetailView.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct JournalDetailView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    let entry: JournalEntry
    @Binding var viewModel: JournalViewModel
    
    @State private var showEdit = false
    @State private var showDeleteConfirm = false
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Header with Date and Mood
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.date.formatted(date: .long, time: .omitted))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(colors.primary)
                            
                            Text(entry.title)
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(colors.foreground)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        
                        Text(entry.mood.rawValue)
                            .font(.system(size: 40))
                            .padding(12)
                            .background(colors.primary.opacity(0.05))
                            .clipShape(Circle())
                    }
                    .padding(.top, AppSpacing.md)
                    
                    // Reference Chip
                    if let ref = entry.reference, !ref.isEmpty {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 14))
                            Text(ref)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(colors.primary.opacity(0.1))
                        .foregroundColor(colors.primary)
                        .cornerRadius(12)
                    }
                    
                    // Content
                    Text(entry.content)
                        .font(.system(size: 18))
                        .lineSpacing(8)
                        .foregroundColor(colors.foreground.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                    Spacer(minLength: 50)
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle(appEnv.language.localizedString("journal_detail_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { showEdit = true }) {
                        Label(appEnv.language.localizedString("journal_edit_btn"), systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showDeleteConfirm = true }) {
                        Label(appEnv.language.localizedString("quran_delete"), systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            AddJournalView(viewModel: $viewModel, editingEntry: entry)
        }
        .alert(appEnv.language.localizedString("journal_delete_confirm"), isPresented: $showDeleteConfirm) {
            Button(appEnv.language.localizedString("quran_cancel"), role: .cancel) { }
            Button(appEnv.language.localizedString("quran_delete"), role: .destructive) {
                viewModel.deleteEntry(id: entry.id)
                dismiss()
            }
        }
    }
}
