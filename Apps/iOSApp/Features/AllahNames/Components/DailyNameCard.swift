//
//  DailyNameCard.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI

struct DailyNameCard: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let item: AsmaNameEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appEnv.language.localizedString("allahnames_daily_title"))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    Text("\(item.number) of 99")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text(item.arabic ?? "")
                    .font(.custom("KFGQPCUthmanTahaNaskh-Regular", size: 40))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.transliteration)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(colors.foreground)
                    
                    Text(item.english ?? "")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(colors.foreground.opacity(0.6))
                        .italic()
                }
                
                HStack {
                    HStack {
                        Text(appEnv.language.localizedString("dua_see_detail"))
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(colors.primary)
                    .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(colors.primary.opacity(0.05))
        )
        .padding(.horizontal, 24)
    }
}
