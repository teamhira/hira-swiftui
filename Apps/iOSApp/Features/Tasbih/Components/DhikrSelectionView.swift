//
//  DhikrSelectionView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct DhikrSelectionView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDhikrIds: Set<UUID>
    
    @State private var selectedTab: Int = 0 // 0: All, 1: Daily
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    private var filteredDhikr: [Dhikr] {
        if selectedTab == 1 {
            return Dhikr.sampleDhikr.filter { $0.isDaily }
        }
        return Dhikr.sampleDhikr
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Tab Picker
                HStack(spacing: 0) {
                    TabButton(title: "All", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TabButton(title: "Daily", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                List {
                    ForEach(filteredDhikr) { dhikr in
                        Button(action: {
                            if selectedDhikrIds.contains(dhikr.id) {
                                selectedDhikrIds.remove(dhikr.id)
                            } else {
                                selectedDhikrIds.insert(dhikr.id)
                            }
                        }) {
                            HStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(selectedDhikrIds.contains(dhikr.id) ? colors.primary : colors.foreground.opacity(0.05))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: selectedDhikrIds.contains(dhikr.id) ? "checkmark" : "plus")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(selectedDhikrIds.contains(dhikr.id) ? .white : colors.foreground.opacity(0.3))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dhikr.arabic)
                                        .font(.title3.bold())
                                        .foregroundColor(colors.foreground)
                                    
                                    Text(dhikr.transliteration)
                                        .font(.subheadline)
                                        .foregroundColor(colors.foreground.opacity(0.6))
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(colors.foreground.opacity(0.1))
                    }
                }
                .listStyle(.plain)
            }
            .background(colors.background.ignoresSafeArea())
            .navigationTitle("Select Dhikr")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    @ViewBuilder
    private func TabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? colors.primary : colors.foreground.opacity(0.4))
                
                Capsule()
                    .fill(isSelected ? colors.primary : Color.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
