//
//  CharityCommunityCauseRow.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct CharityCommunityCauseRow: View {
    let title: String
    let progress: Double
    let raised: Int
    let donors: Int
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                
                HStack(spacing: 8) {
                    ProgressView(value: progress)
                        .tint(colors.primary)
                        .frame(height: 4)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .clipShape(Capsule())
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(raised)")
                    .font(.caption.bold())
                    .foregroundColor(colors.foreground)
                Text(String(format: appEnv.language.localizedString("charity_donors_count"), donors))
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .hiraCleanCard(colors: colors)
    }
}
