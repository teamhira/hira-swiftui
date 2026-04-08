//
//  CharityUrgentCauseRow.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct CharityUrgentCauseRow: View {
    let title: String
    let subtitle: String
    let current: Int
    let target: Int
    let image: String
    let color: Color
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(appEnv.language.localizedString("charity_urgent_badge"))
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Text(title)
                    .font(.subheadline.bold())
                
                VStack(spacing: 4) {
                    ProgressView(value: Double(current), total: Double(target))
                        .tint(color)
                    
                    HStack {
                        let raisedStr = appEnv.language.localizedString("charity_raised_of")
                        Text(raisedStr)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .padding(12)
        .hiraCleanCard(colors: colors)
    }
}
