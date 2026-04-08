//
//  FeatureView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

public struct FeatureView<Content: View>: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(AppRouter.self) private var router
    let titleKey: String
    let icon: String
    let content: Content
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init(titleKey: String, icon: String, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.icon = icon
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { router.pop() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colors.primary)
                }
                
                Spacer()
                
                Text(appEnv.language.localizedString(titleKey))
                    .font(.headline.bold())
                    .foregroundColor(colors.foreground)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(colors.primary)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(colors.background)
            
            // Content
            ScrollView {
                content
                    .padding(24)
            }
            .background(colors.background)
        }
        .navigationBarBackButtonHidden(true)
    }
}
