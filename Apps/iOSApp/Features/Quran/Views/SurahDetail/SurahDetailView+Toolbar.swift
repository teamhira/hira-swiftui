//
//  SurahDetailView+Toolbar.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

extension SurahDetailView {
    func titleToolbar(colors: ThemeModel) -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Button(action: { showingSurahPicker = true }) {
                HStack(spacing: 4) {
                    Text(currentSurah.name)
                        .font(.system(size: 17, weight: .semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(colors.foreground)
            }
        }
    }
    
    func actionToolbar(colors: ThemeModel) -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 12) {
                Button(action: { 
                    viewModel.toggleAutoScroll(for: currentSurah)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    if viewModel.autoScroll {
                        Image(systemName: "scroll.fill")
                            .foregroundColor(colors.primary)
                    } else {
                        Image(systemName: "scroll")
                            .foregroundColor(colors.foreground)
                    }
                }
                .help("Auto Scroll")
                
                Button(action: { viewModel.showingInfo = true }) {
                    Image(systemName: "info.circle")
                }
                Button(action: { viewModel.showingSettings = true }) {
                    Image(systemName: "gearshape")
                }
            }
            .foregroundColor(colors.foreground)
        }
    }
}
