//
//  DeenActiveSessionView.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct DeenActiveSessionView: View {
    let focusType: DeenFocusType
    let duration: String
    let colors: ThemeModel
    let onStop: () -> Void
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            // Subtle animated background elements
            Circle()
                .fill(colors.primary.opacity(0.05))
                .frame(width: 400, height: 400)
                .offset(x: -100, y: -200)
                .blur(radius: 60)
            
            Circle()
                .fill(colors.primary.opacity(0.03))
                .frame(width: 300, height: 300)
                .offset(x: 100, y: 200)
                .blur(radius: 50)
            
            VStack(spacing: 40) {
                Spacer()
                
                // Focus Icon & Status
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .stroke(colors.primary.opacity(0.1), lineWidth: 4)
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: focusType.icon)
                            .font(.system(size: 48))
                            .foregroundColor(colors.primary)
                    }
                    
                    Text(appEnv.language.localizedString("deenmode_active_title"))
                        .font(TextStyle.title3)
                        .fontWeight(.black)
                        .foregroundColor(colors.foreground)
                    
                    Text(appEnv.language.localizedString(focusType.titleKey))
                        .font(TextStyle.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(colors.primary.opacity(0.1))
                        .cornerRadius(20)
                }
                
                // Timer
                Text(duration)
                    .font(.system(size: 64, weight: .thin, design: .monospaced))
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("deenmode_active_desc"))
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // End Session Button
                Button(action: onStop) {
                    HStack(spacing: 12) {
                        Image(systemName: "xmark.circle.fill")
                        Text(appEnv.language.localizedString("deenmode_stop_session"))
                    }
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(24)
                    .shadow(color: Color.red.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 60)
            }
        }
    }
}
