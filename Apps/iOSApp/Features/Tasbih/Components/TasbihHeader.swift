//
//  TasbihHeader.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct TasbihHeader: View {
    @Environment(\.appEnvironment) private var appEnv
    let onBack: () -> Void
    let onReset: () -> Void
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(colors.primary)
            }
            .accessibilityLabel(appEnv.language.localizedString("accessibility_button_back"))
            
            Spacer()
            
            Text(appEnv.language.localizedString("tasbih_title"))
                .font(.title3.bold())
                .foregroundColor(colors.foreground)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: onReset) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title3)
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel(appEnv.language.localizedString("tasbih_reset"))
                
                Button(action: {}) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                        .foregroundColor(colors.primary)
                }
                .accessibilityLabel(appEnv.language.localizedString("tasbih_sound"))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}
