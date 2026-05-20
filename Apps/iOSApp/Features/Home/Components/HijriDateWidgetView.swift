//
//  HijriDateWidgetView.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct HijriDateWidgetView: View {
    let colors: ThemeModel
    @StateObject private var viewModel = HijriDateWidgetViewModel()
    @Environment(\.appEnvironment) private var appEnv
    @State private var showInfo: Bool = false
    
    var body: some View {
        Group {
            if let hijri = viewModel.hijriDate {
                HStack(spacing: 12) {
                    // Hijri Day Number
                    Text("\(hijri.day)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        // Hijri Month & Year
                        Text("\(hijri.monthName) \(String(hijri.year))")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // Arabic Hijri Month
                        Text(hijri.monthNameArabic)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Info Button
                    Button(action: { showInfo = true }) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        colors.primary
                        LinearGradient(
                            colors: [colors.secondary.opacity(0.6), .clear],
                            startPoint: .bottomTrailing,
                            endPoint: .topLeading
                        )
                    }
                )
                .cornerRadius(20)
                .shadow(color: colors.primary.opacity(0.2), radius: 10, x: 0, y: 5)
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(height: 74)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .onAppear {
            if viewModel.hijriDate == nil {
                viewModel.fetchHijriDate()
            }
        }
        .sheet(isPresented: $showInfo) {
            HijriInfoView(
                hijri: viewModel.hijriDate,
                gregorian: viewModel.gregorianDate,
                info: viewModel.islamicInfo,
                colors: colors
            )
            .presentationDetents([.medium, .large])
        }
    }
}

private struct HijriInfoView: View {
    let hijri: HijriDate?
    let gregorian: GregorianDate?
    let info: UmmahIslamicInfo?
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Summary Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appEnv.language.localizedString("home_hijri_widget_title"))
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            infoRow(title: "Hijri", value: hijri?.formatted ?? "--")
                            infoRow(title: "Year", value: "\(hijri?.year ?? 0) \(hijri?.era ?? "AH")")
                        }
                        
                        if let gregorian = gregorian {
                            Divider()
                            infoRow(title: "Gregorian Reference", value: gregorian.formatted)
                        }
                    }
                    .padding()
                    .background(colors.primary.opacity(0.05))
                    .cornerRadius(16)
                    
                    if let info = info {
                        // Calendar Details
                        VStack(alignment: .leading, spacing: 16) {
                            detailRow(title: "Calendar Type", value: info.calendarType)
                            detailRow(title: "Hijri Era Start", value: info.hijriEraStart)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .font(.subheadline.bold())
                                    .foregroundColor(colors.primary)
                                Text(info.note)
                                    .font(.body)
                                    .foregroundColor(colors.foreground.opacity(0.7))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Calendar Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(appEnv.language.localizedString("common_close")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.secondary)
            Text(value)
                .font(.body.bold())
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(colors.primary)
            Text(value)
                .font(.body)
                .foregroundColor(colors.foreground)
        }
    }
}
