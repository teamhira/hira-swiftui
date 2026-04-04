//
//  TasbihCounter.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import SwiftUI

struct TasbihCounter: View {
    @Environment(\.appEnvironment) private var appEnv
    let count: Int
    let target: Int
    let loop: Int
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        VStack(spacing: 40) {
            // Loop Text
            Text(String(format: appEnv.language.localizedString("tasbih_loop"), loop))
                .font(.headline)
                .foregroundColor(colors.foreground.opacity(0.6))
            
            // Counter
            VStack(spacing: 8) {
                Text(String(format: "%02d", count))
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
                    .contentTransition(.numericText()) // Smooth numeric changes on iOS 17+
                
                HStack(spacing: 4) {
                    Text("/ \(target)")
                        .font(.title3.bold())
                        .foregroundColor(colors.foreground.opacity(0.4))
                    
                    Image(systemName: "pencil")
                        .font(.caption)
                        .foregroundColor(colors.primary.opacity(0.5))
                }
            }
        }
    }
}
