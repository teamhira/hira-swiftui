//
//  TarteelHistoryView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct TarteelHistoryView: View {
    @Bindable var viewModel: TarteelViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if viewModel.history.isEmpty {
                        emptyState
                    } else {
                        historyList
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Tarteel History")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 100)
            Image(systemName: "mic.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(colors.primary.opacity(0.2))
            
            Text("No recitation history")
                .font(.title3.bold())
                .foregroundColor(colors.foreground)
            
            Text("Start reciting surahs to see your progress and AI feedback here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var historyList: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.history) { item in
                TarteelHistoryRow(item: item)
            }
        }
    }
}

private struct TarteelHistoryRow: View {
    let item: TarteelHistoryItem
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(colors.primary.opacity(0.1), lineWidth: 3)
                    .frame(width: 44, height: 44)
                
                Circle()
                    .trim(from: 0, to: item.score)
                    .stroke(colors.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(item.score * 100))%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.surahName)
                    .font(.headline)
                    .foregroundColor(colors.foreground)
                
                Text(dateString(for: item.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(item.surahNameArabic)
                .font(.custom("Amiri-Bold", size: 20))
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
    
    private func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
