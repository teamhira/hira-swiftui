//
//  TasbihMissionCompletionView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct TasbihMissionCompletionView: View {
    @Environment(\.appEnvironment) private var appEnv
    let mission: Mission
    let colors: ThemeModel
    let onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(colors.primary)
            }
            
            VStack(spacing: 12) {
                Text(appEnv.language.localizedString("tasbih_mission_finished_title"))
                    .font(.title2.bold())
                
                Text(appEnv.language.localizedString("tasbih_mission_finished_desc"))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("\(mission.expReward)")
                        .font(.headline.bold())
                        .foregroundColor(colors.primary)
                    Text("XP")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 80, height: 80)
                .background(colors.primary.opacity(0.05))
                .cornerRadius(20)
                
                VStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.green)
                    Text("DONE")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 80, height: 80)
                .background(Color.green.opacity(0.05))
                .cornerRadius(20)
            }
            
            Spacer()
            
            Button(action: onDone) {
                Text(appEnv.language.localizedString("tasbih_mission_back_hijrah"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(colors.primary)
                    .cornerRadius(16)
            }
            .padding(24)
        }
        .background(colors.background)
    }
}
