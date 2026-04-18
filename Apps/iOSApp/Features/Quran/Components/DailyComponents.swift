//
//  DailyComponents.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct DailyAyahCard: View {
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appEnv.language.localizedString("quran_daily_title")).font(.caption.bold()).foregroundColor(colors.primary).kerning(1)
                    Text(appEnv.language.localizedString("quran_daily_ayah_ref")).font(.headline.bold())
                }
                Spacer()
                Image(systemName: "sun.max.fill").font(.title2).foregroundColor(.orange)
            }
            
            Text(appEnv.language.localizedString("quran_daily_ayah_content"))
                .font(.system(size: 18, weight: .medium, design: .serif)).multilineTextAlignment(.center).italic().padding(.vertical, 8)
            
            HStack {
                Button(action: {}) { Label(appEnv.language.localizedString("quran_daily_button_share"), systemImage: "square.and.arrow.up").font(.caption.bold()) }
                Spacer()
                Button(action: {}) { Label(appEnv.language.localizedString("quran_daily_button_read_more"), systemImage: "arrow.right.circle.fill").font(.caption.bold()) }
            }
            .foregroundColor(colors.primary)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(colors.background))
        .shadow(color: colors.foreground.opacity(0.03), radius: 15, x: 0, y: 10)
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
    }
}

public struct DailyReminderCard: View {
    let reminder: DailyReminder
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(colors.primary.opacity(0.1))
                    .frame(height: 200)
                    .overlay(LinearGradient(colors: [colors.primary.opacity(0.2), colors.accent.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                if !reminder.image.isEmpty {
                    Image(systemName: "sparkles").font(.largeTitle).foregroundColor(colors.primary.opacity(0.3)).frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            VStack(alignment: .leading, spacing: 12) {
                Text(reminder.title).font(.title3.bold())
                Text(reminder.description).font(.subheadline).foregroundColor(colors.foreground.opacity(0.7)).lineSpacing(4)
                Text("- \(reminder.reference)").font(.caption.bold()).foregroundColor(colors.primary)
                Text(reminder.arabicText).font(.system(size: 20, weight: .medium, design: .serif)).multilineTextAlignment(.trailing).frame(maxWidth: .infinity, alignment: .trailing).padding(.top, 8)
                
                HStack(spacing: 24) {
                    Text(reminder.time).font(.caption.bold()).foregroundColor(colors.foreground.opacity(0.4))
                    Spacer()
                    HStack(spacing: 20) {
                        InteractionButton(icon: "heart", count: reminder.likes)
                        InteractionButton(icon: "bookmark", count: reminder.bookmarks)
                        InteractionButton(icon: "arrowshape.turn.up.right", count: reminder.shares)
                    }
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 4)
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 30)
    }
}

private struct InteractionButton: View {
    let icon: String
    let count: Int
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 14))
            Text("\(count)").font(.system(size: 12, weight: .bold))
        }
        .foregroundColor(colors.foreground.opacity(0.6))
    }
}
