//
//  SurahDetailView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahDetailView: View {
    let surah: Surah
    @Environment(\.appEnvironment) private var appEnv
    
    public init(surah: Surah) {
        self.surah = surah
    }
    
    public var body: some View {
        let colors = appEnv.theme.current
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color(colors.primary), Color(colors.accent)], startPoint: .top, endPoint: .bottom))
                    .frame(height: 150)
                
                VStack {
                    Text(surah.nameArabic)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    Text(surah.name)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(surah.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SurahDetailView(surah: Surah.preview)
    }
}
