//
//  AllahNameRow.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI

struct AllahNameRow: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: AsmaNameEntity
    
    var body: some View {
        HStack(spacing: 16) {
            // Number Circle
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Text("\(item.number)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.transliteration)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colors.foreground)
                
                Text(item.english ?? "")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(colors.foreground.opacity(0.6))
            }
            
            Spacer()
            
            Text(item.arabic ?? "")
                .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 22))
                .foregroundColor(colors.foreground)
        }
        .padding(18)
        .background(colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .hiraCleanCard(colors: colors)
    }
}
