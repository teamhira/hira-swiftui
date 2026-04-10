//
//  TarteelView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

public struct TarteelView: View {
    @State private var viewModel = TarteelViewModel()
    @Environment(AppRouter.self) private var router
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            TarteelSurahListView(viewModel: viewModel)
        }
        .navigationTitle("Tarteel AI")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { router.navigate(to: .tarteelHistory) }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(colors.primary)
                }
            }
        }
    }
}

#Preview {
    TarteelView()
        .environment(\.appEnvironment, AppEnvironment(theme: ThemeManager(), security: SecurityManager(), language: LanguageManager(), di: DIContainer.shared))
}
