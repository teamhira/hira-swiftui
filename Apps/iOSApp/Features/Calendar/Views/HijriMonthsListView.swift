//
//  HijriMonthsListView.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct HijriMonthsListView: View {
    let months: [UmmahIslamicMonth]
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(months) { month in
                        HijriMonthInfoCard(month: month, colors: colors)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(appEnv.language.localizedString("calendar_islamic_months"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
