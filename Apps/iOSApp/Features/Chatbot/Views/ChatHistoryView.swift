//
//  ChatHistoryView.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct ChatHistoryView: View {
    @Bindable var viewModel: ChatbotViewModel
    let colors: ThemeModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var sessionToDelete: ChatSession?
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                if viewModel.sessions.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 64))
                            .foregroundColor(colors.foreground.opacity(0.1))
                        
                        Text(appEnv.language.localizedString("chatbot_empty_history"))
                            .font(TextStyle.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.6))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.sessions) { session in
                                ChatHistoryRow(session: session, colors: colors) {
                                    sessionToDelete = session
                                    showDeleteAlert = true
                                }
                                .onTapGesture {
                                    viewModel.loadSession(session)
                                    dismiss()
                                }
                            }
                        }
                        .padding(AppSpacing.md)
                    }
                }
            }
            .navigationTitle(appEnv.language.localizedString("chatbot_history_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(appEnv.language.localizedString("common_close")) {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(colors.primary)
                }
            }
            .alert(appEnv.language.localizedString("chatbot_delete_confirm_title"), isPresented: $showDeleteAlert) {
                Button(appEnv.language.localizedString("quran_delete"), role: .destructive) {
                    if let session = sessionToDelete {
                        withAnimation {
                            viewModel.deleteSession(session)
                        }
                    }
                }
                Button(appEnv.language.localizedString("common_cancel"), role: .cancel) {}
            } message: {
                Text(appEnv.language.localizedString("chatbot_delete_confirm_msg"))
            }
        }
    }
}
