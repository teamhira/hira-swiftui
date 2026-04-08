//
//  MoreFeaturesSheet.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct MoreFeaturesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    let colors: ThemeModel
    
    @State var store: HomeFeatureStoreModel
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(store.features) { item in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(colors.primary.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: item.type.icon)
                                    .foregroundColor(colors.primary)
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(appEnv.language.localizedString(item.type.titleKey))
                                    .font(.body.bold())
                                    .foregroundColor(colors.foreground)
                                
                                if let descKey = item.type.descriptionKey {
                                    Text(appEnv.language.localizedString(descKey))
                                        .font(.caption)
                                        .foregroundColor(colors.foreground.opacity(0.6))
                                } else if !item.isVisible {
                                    Text(appEnv.language.localizedString("home_feature_hidden"))
                                        .font(.caption)
                                        .foregroundColor(colors.foreground.opacity(0.6))
                                }
                            }
                            
                            Spacer()
                            
                            if editMode == .inactive {
                                Toggle("", isOn: Binding(
                                    get: { item.isVisible },
                                    set: { _ in store.toggleVisibility(for: item.type) }
                                ))
                                .labelsHidden()
                                .tint(colors.primary)
                            }
                        }
                        .listRowBackground(colors.background)
                        .listRowSeparatorTint(colors.foreground.opacity(0.1))
                    }
                    .onMove(perform: store.move)
                } header: {
                    Text(appEnv.language.localizedString("home_more_features_header"))
                        .font(.footnote.bold())
                        .foregroundColor(colors.foreground.opacity(0.6))
                } footer: {
                    Text(appEnv.language.localizedString("home_more_features_footer"))
                        .font(.caption)
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(colors.background)
            .navigationTitle(appEnv.language.localizedString("home_feature_more"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(appEnv.language.localizedString("common_close")) {
                        dismiss()
                    }
                    .foregroundColor(colors.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .foregroundColor(colors.primary)
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
}
