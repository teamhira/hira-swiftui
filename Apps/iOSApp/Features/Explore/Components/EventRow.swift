//
//  EventRow.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct EventRow: View {
    let event: ExploreEvent
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(colors.primary.opacity(0.1))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "building.columns.fill")
                        .foregroundColor(colors.primary.opacity(0.5))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.date)
                    .font(.caption2.bold())
                    .foregroundColor(colors.primary)
                
                Text(event.title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                
                Text(event.location)
                    .font(.caption2)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(colors.foreground.opacity(0.3))
                    .padding(10)
                    .background(Circle().fill(colors.foreground.opacity(0.04)))
            }
        }
        .padding(AppSpacing.sm)
        .hiraCleanCard(colors: colors)
        .accessibilityElement(children: .combine)
    }
}
