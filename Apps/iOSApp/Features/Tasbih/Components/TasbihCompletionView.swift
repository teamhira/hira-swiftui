//
//  TasbihCompletionView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct TasbihCompletionView: View {
    @Environment(\.appEnvironment) private var appEnv
    let onRestart: () -> Void
    let onClose: () -> Void
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 50))
                    .foregroundColor(colors.primary)
            }
            
            VStack(spacing: 8) {
                Text(appEnv.language.localizedString("tasbih_completion_title"))
                    .font(.title.bold())
                    .foregroundColor(colors.foreground)
                
                Text(appEnv.language.localizedString("tasbih_completion_desc"))
                    .font(.body)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onRestart()
            } label: {
                Text(appEnv.language.localizedString("tasbih_restart"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(colors.primary)
                    .clipShape(Capsule())
            }
            .padding(.top, 20)
            
            Button {
                onClose()
            } label: {
                Text(appEnv.language.localizedString("tasbih_close"))
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
        }
        .padding(40)
        .presentationDetents([.height(450)])
        .presentationDragIndicator(.visible)
    }
}
