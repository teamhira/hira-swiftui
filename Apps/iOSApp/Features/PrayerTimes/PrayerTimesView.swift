//
//  PrayerTimesView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

public struct PrayerTimesView: View {
    @State private var viewModel = PrayerTimesViewModel()
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Modern Header Card
                    VStack(spacing: 16) {
                        Text("Next Prayer")
                            .font(.subheadline.bold())
                            .foregroundColor(colors.primary)
                        
                        Text("Asr • 15:15")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(colors.foreground)
                        
                        Text("1 hour 15 minutes remaining")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(32)
                    .frame(maxWidth: .infinity)
                    .background(colors.foreground.opacity(0.03))
                    .cornerRadius(32)
                    .padding(.horizontal, 24)
                    
                    // Times List
                    VStack(spacing: 16) {
                        ForEach(viewModel.prayerTimes.sorted(by: { $0.value < $1.value }), id: \.key) { name, time in
                            HStack {
                                Text(name)
                                    .font(.headline)
                                    .foregroundColor(colors.foreground)
                                
                                Spacer()
                                
                                Text(time)
                                    .font(.title3.bold().monospacedDigit())
                                    .foregroundColor(colors.primary)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(colors.foreground.opacity(0.04)))
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 24)
            }
        }
        .navigationTitle("Prayer Times")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrayerTimesView()
            .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
    }
}
