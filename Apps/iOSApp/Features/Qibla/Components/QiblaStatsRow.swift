//
//  QiblaStatsRow.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct QiblaStatsRow: View {
    @Environment(\.appEnvironment) private var appEnv
    let qiblaDirection: Double
    let heading: Double
    let distanceToMecca: Double
    let cardinalDirection: String
    let style: QiblaCompassStyle
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(appEnv.language.localizedString("qibla_bearing_label", defaultValue: "Qibla Bearing"))
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(colors.foreground.opacity(0.4))
                
                Text("\(Int(qiblaDirection))° \(cardinalDirection)")
                    .font(.title3.bold())
                    .foregroundColor(style.color)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(appEnv.language.localizedString("qibla_bearing_label", defaultValue: "Qibla Bearing")): \(Int(qiblaDirection)) degrees \(cardinalDirection)")
            
            Spacer()
            
            HStack(spacing: 12) {
                labelValue(label: appEnv.language.localizedString("qibla_heading_label", defaultValue: "Heading"), value: "\(Int(heading))°")
                labelValue(label: appEnv.language.localizedString("qibla_mecca_label", defaultValue: "Mecca"), value: distanceToMecca > 0 ? "\(Int(distanceToMecca)) km" : appEnv.language.localizedString("qibla_finding_status", defaultValue: "Finding..."))
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md - 4)
        .hiraCleanCard(colors: colors, radius: 24)
        .padding(.horizontal, AppSpacing.md)
    }
    
    private func labelValue(label: String, value: String) -> some View {
        VStack(alignment: .trailing, spacing: 1) {
            Text(label)
                .font(.system(size: 7, weight: .bold))
                .foregroundColor(colors.foreground.opacity(0.3))
                .textCase(.uppercase)
            
            Text(value)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(colors.foreground)
        }
    }
}
