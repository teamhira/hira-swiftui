//
//  JournalView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = JournalViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "home_feature_journal", icon: "note.text") {
            VStack(spacing: 32) {
                // New Entry Card
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appEnv.language.localizedString("journal_new_entry_title"))
                            .font(.headline.bold())
                            .foregroundColor(colors.foreground)
                        Text(appEnv.language.localizedString("journal_new_entry_desc"))
                            .font(.caption)
                            .foregroundColor(colors.foreground.opacity(0.6))
                        
                        Button(action: {}) {
                            Text(appEnv.language.localizedString("journal_add_btn"))
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(colors.primary)
                                .cornerRadius(20)
                        }
                    }
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .font(.largeTitle)
                        .foregroundColor(colors.primary)
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                
                // Timeline List
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("journal_timeline_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.entries) { entry in
                            HStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    Text("\(entry.day)")
                                        .font(.title3.bold())
                                        .foregroundColor(colors.primary)
                                    Text(entry.monthAbb)
                                        .font(.caption2.bold())
                                        .foregroundColor(colors.foreground.opacity(0.4))
                                }
                                .frame(width: 50, height: 50)
                                .background(colors.primary.opacity(0.1))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title)
                                        .font(.subheadline.bold())
                                        .foregroundColor(colors.foreground)
                                    Text(entry.preview)
                                        .font(.caption)
                                        .foregroundColor(colors.foreground.opacity(0.6))
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(colors.foreground.opacity(0.3))
                            }
                            .padding(16)
                            .background(colors.background)
                            .hiraCleanCard(colors: colors, radius: 16)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(appEnv.language.localizedString("journal_accessibility_entry", arguments: ["\(entry.day) \(entry.monthAbb)", entry.title, entry.preview]))
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                }
            }
            .eraseToAnyView()
        }
    }
}
#Preview {
    NavigationStack {
        JournalView()
            .environment(AppState())
    }
}
