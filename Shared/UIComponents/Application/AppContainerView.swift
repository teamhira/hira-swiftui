//
//  AppContainerView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct AppContainerView<Content: View>: View {
    @Environment(\.appEnvironment) private var appEnv
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    private var theme: ThemeManager { appEnv.theme }
    private var colors: ThemeModel { theme.current }
    
    public var body: some View {
        let scheme: ColorScheme = theme.isDark ? .dark : .light
        
        ZStack {
            colors.background
                .ignoresSafeArea()
            
            content
                .environment(\.colorScheme, scheme)
                .preferredColorScheme(scheme)
                .tint(colors.primary)
        }
        .animation(.easeInOut, value: theme.variant)
        .animation(.easeInOut, value: theme.isDark)
    }
}
