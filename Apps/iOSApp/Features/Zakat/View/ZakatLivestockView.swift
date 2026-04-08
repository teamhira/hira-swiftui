//
//  ZakatLivestockView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

public struct ZakatLivestockView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = ZakatViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    // Educational Section (Side Aligned)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "hare.fill")
                                .font(.headline)
                                .foregroundColor(colors.primary)
                                .accessibilityHidden(true)
                        }
                        
                        Text(appEnv.language.localizedString("zakat_desc_livestock"))
                            .font(.caption)
                            .foregroundColor(colors.foreground.opacity(0.6))
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(colors.background)
                    .hiraCleanCard(colors: colors, radius: 20)
                    .cornerRadius(20)
                    
                    // Input (Multi-field)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(appEnv.language.localizedString("zakat_label_people")) // Reusing unit for count
                                .font(.subheadline.bold())
                                .foregroundColor(colors.foreground)
                            
                            TextField("40", text: $viewModel.currentAsset)
                                .padding()
                                .background(colors.foreground.opacity(0.04))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                                .accessibilityLabel(appEnv.language.localizedString("zakat_label_amount"))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(appEnv.language.localizedString("zakat_label_price_unit"))
                                .font(.subheadline.bold())
                                .foregroundColor(colors.foreground)
                            
                            TextField("3000000", text: $viewModel.assetPrice)
                                .padding()
                                .background(colors.foreground.opacity(0.04))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                                .accessibilityLabel(appEnv.language.localizedString("zakat_label_price_unit"))
                        }
                        
                        Button(action: {
                            viewModel.selectedType = .ternak
                            viewModel.calculate()
                            viewModel.addRecord()
                        }) {
                            Text(appEnv.language.localizedString("zakat_button_calculate"))
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(colors.primary)
                                .cornerRadius(12)
                        }
                        .accessibilityHint(appEnv.language.localizedString("zakat_calculate_btn"))
                    }
                    .padding(20)
                    .background(colors.background)
                    .hiraCleanCard(colors: colors, radius: 20)
                    .cornerRadius(20)
                    
                    if viewModel.calculatedZakat > 0 {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(appEnv.language.localizedString("zakat_result_total"))
                                .font(.caption.bold())
                                .foregroundColor(colors.foreground.opacity(0.5))
                            
                            Text("Rp \(Int(viewModel.calculatedZakat).formattedWithSeparator)")
                                .font(.title3.bold())
                                .foregroundColor(colors.primary)
                                .accessibilityLabel("\(appEnv.language.localizedString("zakat_result_total")): Rp \(Int(viewModel.calculatedZakat).formattedWithSeparator)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(colors.primary.opacity(0.05))
                        .cornerRadius(16)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(12)
            }
        }
        .navigationTitle(appEnv.language.localizedString("zakat_title_livestock"))
        .navigationBarTitleDisplayMode(.large)
    }
}
