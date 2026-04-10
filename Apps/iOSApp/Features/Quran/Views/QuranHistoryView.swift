//
//  QuranHistoryView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct QuranHistoryView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        let historyByDay = Dictionary(grouping: viewModel.history) { item in
                            Calendar.current.startOfDay(for: item.date)
                        }
                        
                        let sortedDays = historyByDay.keys.sorted(by: >)
                        
                        if viewModel.history.isEmpty {
                            VStack(spacing: 16) {
                                Spacer(minLength: 100)
                                Image(systemName: "clock.badge.questionmark")
                                    .font(.system(size: 64))
                                    .foregroundColor(colors.primary.opacity(0.2))
                                
                                Text("No reading history yet")
                                    .font(.title3.bold())
                                    .foregroundColor(colors.foreground)
                                
                                Text("Your recently read surahs and ayahs will appear here.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            ForEach(sortedDays, id: \.self) { day in
                                Section {
                                    VStack(spacing: 12) {
                                        ForEach(historyByDay[day] ?? []) { item in
                                            HistoryRow(item: item)
                                        }
                                    }
                                } header: {
                                    Text(dateString(for: day))
                                        .font(.headline.bold())
                                        .foregroundColor(colors.primary)
                                        .padding(.horizontal, 24)
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Reading History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(colors.primary)
                }
            }
        }
    }
    
    private func dateString(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }
}

private struct HistoryRow: View {
    let item: QuranHistoryItem
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            // Circle Number
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Text("\(item.surahNumber)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.surahName)
                    .font(.headline)
                    .foregroundColor(colors.foreground)
                
                Text("Ayah \(item.ayahNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(item.surahNameArabic)
                .font(.custom("Amiri-Bold", size: 20)) // Using a common Arabic font or default
                .foregroundColor(colors.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colors.foreground.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(colors.foreground.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    QuranHistoryView(viewModel: QuranViewModel())
        .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
}
