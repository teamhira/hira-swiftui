//
//  AllahNamesListView.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI

struct AllahNamesListView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    let names: [AsmaNameEntity]
    
    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(names) { item in
                        NavigationLink(destination: AllahNameDetailView(item: item)) {
                            AllahNameRow(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle(appEnv.language.localizedString("allahnames_list_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
