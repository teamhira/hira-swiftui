//
//  JourneyProfileCard.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct JourneyProfileCard: View {
    @Environment(\.appEnvironment) private var appEnv
    
    let typeName: String
    let goals: [String]
    let colors: ThemeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(appEnv.language.localizedString("journey_profile_title"))
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "person.fill.viewfinder")
                        .foregroundColor(colors.primary)
                        .frame(width: 40, height: 40)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appEnv.language.localizedString("hijrah_dash_journey_type"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(typeName)
                            .font(.body.bold())
                    }
                    Spacer()
                }
                
                if !goals.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(appEnv.language.localizedString("hijrah_dash_goals"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(goals, id: \.self) { goal in
                                Text(goal)
                                    .font(.system(size: 11, weight: .medium))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(colors.foreground.opacity(0.05))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(colors.background)
                    .hiraCleanCard(colors: colors, radius: 24)
            )
        }
    }
}
