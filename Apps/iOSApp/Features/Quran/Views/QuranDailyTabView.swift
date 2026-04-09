//
//  QuranDailyTabView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct QuranDailyTabView: View {
    let viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Daily Reminder Header
                HStack(spacing: 12) {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(appEnv.theme.current.primary)
                        .font(.title3)
                    
                    Text(appEnv.language.localizedString("quran_daily_reminder_section"))
                        .font(.title3.bold())
                        .foregroundColor(appEnv.theme.current.foreground)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.dailyReminders) { reminder in
                        DailyReminderCard(reminder: reminder)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding(.bottom, 150)
        }
    }
}
