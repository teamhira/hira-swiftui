//
//  ZakatView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Main dashboard for the Zakat feature, listing all available Zakat categories for calculated contribution.
public struct ZakatView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = ZakatViewModel()
    @State private var isShowingInfo: Bool = false
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    // Description Text
                    Text(appEnv.language.localizedString("zakat_calculator_desc"))
                        .font(.subheadline)
                        .foregroundColor(colors.foreground.opacity(0.6))
                        .padding(.horizontal, 16)
                    
                    // Zakat Categories Grid (Specialized Routing)
                    VStack(spacing: 12) {
                        ForEach(ZakatType.allCases) { type in
                            NavigationLink(destination: destination(for: type)) {
                                ZakatTypeCard(type: type, colors: colors)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel(appEnv.language.localizedString(type.localizedTitleKey))
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle(appEnv.language.localizedString("home_feature_zakat"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isShowingInfo = true }) {
                    Image(systemName: "info.circle")
                        .font(.body.bold())
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel(appEnv.language.localizedString("zakat_info_accessibility"))
            }
        }
        .sheet(isPresented: $isShowingInfo) {
            ZakatInfoModal(colors: colors)
        }
    }
    
    @ViewBuilder
    private func destination(for type: ZakatType) -> some View {
        switch type {
        case .fitrah: ZakatFitrahView()
        case .emas: ZakatGoldView()
        case .tani: ZakatAgricultureView()
        case .uang: ZakatSavingsView()
        case .dagang: ZakatTradeView()
        case .ternak: ZakatLivestockView()
        case .tambang: ZakatMiningView()
        case .profesi: ZakatProfessionView()
        }
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
