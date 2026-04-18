//
//  JuzComponents.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

// MARK: - Khatam Progress Card

public struct JuzProgressCard: View {
    let progress: Double
    let stats: String
    let lastRead: String

    @Environment(\.appEnvironment) private var appEnv
    @State private var animatedProgress: Double = 0

    private var colors: ThemeModel { appEnv.theme.current }

    public var body: some View {
        HStack(spacing: 20) {
            // Animated pie / donut chart
            ZStack {
                Circle()
                    .stroke(colors.foreground.opacity(0.06), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        LinearGradient(
                            colors: [colors.primary, colors.primary.opacity(0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.0), value: animatedProgress)

                VStack(spacing: 1) {
                    Text("\(Int(animatedProgress * 100))")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                        .contentTransition(.numericText())
                        .animation(.easeOut(duration: 1.0), value: animatedProgress)
                    Text("%")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
            }
            .frame(width: 80, height: 80)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    animatedProgress = progress
                }
            }
            .onChange(of: progress) { _, new in
                withAnimation(.easeOut(duration: 0.8)) {
                    animatedProgress = new
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(appEnv.language.localizedString("quran_juz_khatam_title"))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(colors.foreground)
                Text(stats)
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                Text(lastRead)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.38))
            }

            Spacer()
        }
        .padding(24)
        .hiraCleanCard(colors: colors, radius: 28)
    }
}

// MARK: - Juz Row

public struct JuzRowView: View {
    let juz: JuzProgress

    @Environment(\.appEnvironment) private var appEnv
    @State private var animatedProgress: Double = 0

    private var colors: ThemeModel { appEnv.theme.current }

    public var body: some View {
        HStack(spacing: 16) {
            // Juz number badge
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                Text("\(juz.number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.primary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: appEnv.language.localizedString("quran_juz_number"), juz.number))
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                Text(juz.surahRange)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .lineLimit(1)
            }

            Spacer()

            // Progress section
            VStack(alignment: .trailing, spacing: 6) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(animatedProgress > 0 ? colors.primary : colors.foreground.opacity(0.3))
                    .contentTransition(.numericText())
                    .animation(.easeOut(duration: 0.8), value: animatedProgress)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(colors.foreground.opacity(0.07))
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [colors.primary, colors.primary.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * animatedProgress)
                            .animation(.easeOut(duration: 0.8), value: animatedProgress)
                    }
                }
                .frame(width: 80, height: 4)
            }
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 24)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatedProgress = juz.progress
            }
        }
        .onChange(of: juz.progress) { _, new in
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = new
            }
        }
    }
}
