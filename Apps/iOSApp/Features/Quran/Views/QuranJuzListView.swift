//
//  QuranJuzListView.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import SwiftUI

public struct QuranJuzListView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    @State private var selectedJuz: JuzProgress?

    private var colors: ThemeModel { appEnv.theme.current }

    public init(viewModel: QuranViewModel) {
        self._viewModel = Bindable(viewModel)
    }

    // MARK: - Computed Progress

    /// Khatam progress: prefer live activity data, fall back to model value.
    private var khatamProgress: Double {
        viewModel.activityDays.isEmpty ? viewModel.khatamProgress : viewModel.activityKhatamProgress
    }

    /// Last-read Juz label derived from the most recent activity day range.
    private var lastReadLabel: String {
        if let day = viewModel.activityDays.first,
           let firstRange = day.ranges.first {
            let parts = firstRange.components(separatedBy: ":")
            if let surahNum = Int(parts.first ?? ""),
               let surah = viewModel.surahs.first(where: { $0.number == surahNum }) {
                return surah.name
            }
        }
        return appEnv.language.localizedString("quran_bookmark_no_last")
    }

    public var body: some View {
        VStack(spacing: 24) {
            // MARK: - Progress Banner
            if viewModel.isFetchingActivityDays && viewModel.activityDays.isEmpty {
                // Skeleton
                HStack(spacing: 20) {
                    Circle()
                        .fill(colors.foreground.opacity(0.06))
                        .frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: 6).fill(colors.foreground.opacity(0.07))
                            .frame(width: 100, height: 14)
                        RoundedRectangle(cornerRadius: 6).fill(colors.foreground.opacity(0.07))
                            .frame(width: 160, height: 12)
                    }
                    Spacer()
                }
                .padding(24)
                .hiraCleanCard(colors: colors, radius: 28)
                .padding(.horizontal, 24)
            } else {
                JuzProgressCard(
                    progress: khatamProgress,
                    stats: String(format: appEnv.language.localizedString("quran_juz_khatam_stat"),
                                  Int(khatamProgress * 30)),
                    lastRead: String(format: appEnv.language.localizedString("quran_juz_khatam_last"),
                                     lastReadLabel)
                )
                .padding(.horizontal, 24)
            }

            // MARK: - Juz List
            if viewModel.isLoading && viewModel.juzList.isEmpty {
                loadingState
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.juzList) { juz in
                        Button(action: { selectedJuz = juz }) {
                            juzRow(juz)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .fullScreenCover(item: $selectedJuz) { juz in
            QuranJuzDetailView(juz: juz)
                .environment(viewModel)
                .environment(router)
        }
        .onAppear {
            viewModel.fetchJuzs()
            viewModel.fetchActivityDays()
        }
    }

    // MARK: - Juz Row with Live Progress

    private func juzRow(_ juz: JuzProgress) -> some View {
        let liveProgress = viewModel.activityDays.isEmpty
            ? juz.progress
            : viewModel.activityProgress(for: juz)

        return JuzRowView(juz: JuzProgress(
            id: juz.id,
            number: juz.number,
            surahRange: juz.surahRange,
            progress: liveProgress,
            verseMapping: juz.verseMapping
        ))
    }

    // MARK: - Loading State

    private var loadingState: some View {
        VStack(spacing: 16) {
            ForEach(0..<8, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 24)
                    .fill(colors.foreground.opacity(0.05))
                    .frame(height: 80)
            }
        }
        .padding(.horizontal, 24)
    }
}
