//
//  MemorizationView.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI

struct MemorizationView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        FeatureView(titleKey: "memorization_title", icon: "brain.head.profile") {
            VStack(spacing: 32) {
                // Summary Card
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appEnv.language.localizedString("memorization_progress"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text("5 Surah • 120 Ayah")
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.6))
                        }
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .font(.title)
                            .foregroundColor(colors.primary)
                    }
                    
                    ProgressView(value: 0.3)
                        .tint(colors.primary)
                }
                .padding(24)
                .background(colors.background)
                .hiraCleanCard(colors: colors, radius: 24)
                
                // Empty State or List
                VStack(spacing: 24) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 48))
                        .foregroundColor(colors.foreground.opacity(0.1))
                    
                    Text(appEnv.language.localizedString("memorization_empty_list"))
                        .font(.subheadline)
                        .foregroundColor(colors.foreground.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "plus")
                            Text(appEnv.language.localizedString("memorization_add_target"))
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(colors.primary)
                        .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
            .padding(.horizontal, 24)
            .eraseToAnyView()
        }
    }
}

#Preview {
    NavigationStack {
        MemorizationView()
            .environment(AppState())
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
