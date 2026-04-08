//
//  MissionCard.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct MissionCard: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    let mission: Mission
    let isLocked: Bool
    let colors: ThemeModel
    let viewModel: HijrahViewModel
    
    var body: some View {
        Button(action: { if !isLocked { router.navigate(to: .missionDetail(mission, viewModel)) } }) {
            HStack(spacing: 16) {
                // Status Icon
                statusIcon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mission.title)
                        .font(.body.bold())
                        .foregroundColor(isLocked ? colors.foreground.opacity(0.3) : colors.foreground)
                        .strikethrough(mission.isCompleted)
                    
                    HStack(spacing: 8) {
                        Text(String(format: appEnv.language.localizedString("hijrah_mission_reward"), mission.expReward))
                            .font(.caption2.bold())
                            .foregroundColor(isLocked ? .secondary.opacity(0.3) : colors.primary)
                        
                        if isLocked {
                            Text(appEnv.language.localizedString("hijrah_mission_locked"))
                                .font(.caption2)
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                }
                
                Spacer()
                
                if mission.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isLocked ? colors.foreground.opacity(0.02) : colors.background)
                    .hiraCleanCard(colors: colors, radius: 18)
            )
        }
        .disabled(isLocked || mission.isCompleted)
        .opacity(isLocked ? 0.6 : 1.0)
    }
    
    private var statusIcon: some View {
        ZStack {
            Circle()
                .fill(isLocked ? Color.gray.opacity(0.1) : colors.primary.opacity(0.1))
                .frame(width: 40, height: 40)
            
            Image(systemName: isLocked ? "lock.fill" : (mission.isCompleted ? "checkmark" : "checklist"))
                .foregroundColor(isLocked ? .gray : colors.primary)
                .font(.system(size: 14, weight: .bold))
        }
    }
}
