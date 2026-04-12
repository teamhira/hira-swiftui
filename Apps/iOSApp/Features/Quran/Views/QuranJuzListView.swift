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
    
    public var body: some View {
        VStack(spacing: 24) {
            JuzProgressCard(
                progress: viewModel.khatamProgress,
                stats: String(format: appEnv.language.localizedString("quran_juz_khatam_stat"), 3),
                lastRead: String(format: appEnv.language.localizedString("quran_juz_khatam_last"), "Juz 1 (Al-Fatihah)")
            )
            .padding(.horizontal, 24)
            
            if viewModel.isLoading && viewModel.juzList.isEmpty {
                loadingState
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.juzList) { juz in
                        Button(action: { selectedJuz = juz }) {
                            JuzRowView(juz: juz)
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
        }
    }
    
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
