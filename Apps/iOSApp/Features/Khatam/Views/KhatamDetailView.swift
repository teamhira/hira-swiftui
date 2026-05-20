//
//  KhatamDetailView.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct KhatamDetailView: View {
    let title: String
    let logs: [KhatamLog]
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            if logs.isEmpty {
                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 60))
                        .foregroundColor(colors.primary.opacity(0.3))
                    Text(appEnv.language.localizedString("khatam_detail_no_logs"))
                        .font(TextStyle.headline)
                        .foregroundColor(colors.foreground)
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: AppSpacing.md) {
                        ForEach(logs.reversed()) { log in
                            logRow(log)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func logRow(_ log: KhatamLog) -> some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDate(log.date))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                
                HStack {
                    Text(appEnv.language.localizedString("khatam_log_range_format", arguments: [log.startSurah, log.startAyah, log.endSurah, log.endAyah]))
                        .font(TextStyle.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(appEnv.language.localizedString("khatam_log_ayahs_added", arguments: [log.ayahsRead]))
                        .font(TextStyle.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(colors.primary.opacity(0.1))
                        .foregroundColor(colors.primary)
                        .clipShape(Capsule())
                }
                .foregroundColor(colors.foreground)
            }
            
            Spacer()
        }
        .padding()
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }


    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
