//
//  QuranSelectionViews.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct TranslationSelectionView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    let options = [
        "English: Abdullah Yusuf Ali",
        "English: Sahih International",
        "English: Pickthall",
        "Bahasa Indonesia: Kemenag"
    ]
    
    public var body: some View {
        let colors = appEnv.theme.current
        List(options, id: \.self) { option in
            HStack {
                Text(option)
                Spacer()
                if viewModel.selectedTranslation == option {
                    Image(systemName: "checkmark").foregroundColor(colors.primary)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectedTranslation = option
                dismiss()
            }
        }
        .navigationTitle("Select Translation")
    }
}

public struct ReciterSelectionView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    let options = [
        "Mishary Rashid Alafasy",
        "Abdul Rahman Al-Sudais",
        "Maher Al-Muaiqly",
        "Saad Al-Ghamdi"
    ]
    
    public var body: some View {
        let colors = appEnv.theme.current
        List(options, id: \.self) { option in
            HStack {
                Text(option)
                Spacer()
                if viewModel.selectedReciter == option {
                    Image(systemName: "checkmark").foregroundColor(colors.primary)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectedReciter = option
                dismiss()
            }
        }
        .navigationTitle("Select Reciter")
    }
}
