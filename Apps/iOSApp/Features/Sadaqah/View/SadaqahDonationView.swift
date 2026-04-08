//
//  SadaqahDonationView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

public struct SadaqahDonationView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = SadaqahViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header with Illustration
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(colors.primary.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "banknote.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(colors.primary)
                    }
                    
                    Text(appEnv.language.localizedString("sadaqah_type_cash_title"))
                        .font(.title2.bold())
                        .foregroundColor(colors.foreground)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                // Input Amount Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(appEnv.language.localizedString("sadaqah_donate_gateway_select_amount"))
                        .font(.subheadline.bold())
                        .foregroundColor(colors.foreground)
                    
                    HStack {
                        Text(appEnv.language.localizedString("common_currency_symbol"))
                            .font(.headline.bold())
                            .foregroundColor(colors.primary)
                        
                        TextField("0", text: $viewModel.amount)
                            .font(.title.bold())
                            .foregroundColor(colors.foreground)
                            .keyboardType(.numberPad)
                    }
                    .padding(24)
                    .background(colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .hiraCleanCard(colors: colors, radius: 20)
                }
                .padding(.horizontal, 24)
                
                // Recommended Amounts
                VStack(alignment: .leading, spacing: 12) {
                    Text(appEnv.language.localizedString("sadaqah_suggested_amount"))
                        .font(.caption.bold())
                        .foregroundColor(colors.foreground.opacity(0.4))
                        .padding(.horizontal, 24)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            AmountPill(amount: "10,000", colors: colors, viewModel: $viewModel)
                            AmountPill(amount: "50,000", colors: colors, viewModel: $viewModel)
                            AmountPill(amount: "100,000", colors: colors, viewModel: $viewModel)
                            AmountPill(amount: "500,000", colors: colors, viewModel: $viewModel)
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                // Payment Gateway Placeholder
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.caption)
                        Text(appEnv.language.localizedString("sadaqah_donate_gateway_hint"))
                            .font(.caption)
                    }
                    .foregroundColor(colors.primary)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(colors.primary.opacity(0.05))
                    .cornerRadius(20)
                }
                .padding(.horizontal, 24)
                
                // Donate Button
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "creditcard.fill")
                        Text(appEnv.language.localizedString("sadaqah_donate_gateway_btn"))
                    }
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(colors.primary)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(colors.background.ignoresSafeArea())
    }
}

private struct AmountPill: View {
    let amount: String
    let colors: ThemeModel
    @Binding var viewModel: SadaqahViewModel
    
    var body: some View {
        Button(action: { viewModel.amount = amount.replacingOccurrences(of: ",", with: "") }) {
            Text(amount)
                .font(.subheadline.bold())
                .foregroundColor(viewModel.amount == amount.replacingOccurrences(of: ",", with: "") ? .white : colors.primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(viewModel.amount == amount.replacingOccurrences(of: ",", with: "") ? colors.primary : colors.primary.opacity(0.1))
                .cornerRadius(16)
        }
    }
}
