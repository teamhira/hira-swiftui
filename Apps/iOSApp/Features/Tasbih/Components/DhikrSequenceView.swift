//
//  DhikrSequenceView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI

struct DhikrSequenceView: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @Binding var sequence: [DhikrSequenceItem]
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    if sequence.isEmpty {
                        Text(appEnv.language.localizedString("tasbih_no_dhikr"))
                            .font(.subheadline)
                            .foregroundColor(colors.foreground.opacity(0.4))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    } else {
                        // Use stable identity (item.id) for move to work correctly
                        ForEach(sequence) { item in
                            dhikrRow(item: item)
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(colors.foreground.opacity(0.1))
                        }
                        .onMove(perform: move)
                    }
                }
                .listStyle(.plain)
            }
            .background(colors.background.ignoresSafeArea())
            .navigationTitle(appEnv.language.localizedString("tasbih_dhikr"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(appEnv.language.localizedString("accessibility_button_done")) { dismiss() }
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    @ViewBuilder
    private func dhikrRow(item: DhikrSequenceItem) -> some View {
        // Calculate index for the sequence number
        let index = sequence.firstIndex(where: { $0.id == item.id }) ?? 0
        
        HStack(spacing: 20) {
            // Sequence Number instead of icon
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Text("\(index + 1)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.dhikr.arabic)
                    .font(.headline)
                    .foregroundColor(colors.foreground)
                
                Text(item.dhikr.transliteration)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
            }
            
            Spacer()
            
            // Loop Customization
            HStack(spacing: 12) {
                Button {
                    if let idx = sequence.firstIndex(where: { $0.id == item.id }), sequence[idx].loops > 1 {
                        sequence[idx].loops -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(colors.primary)
                        .font(.title3)
                }
                .buttonStyle(.plain)
                
                VStack(spacing: 2) {
                    Text("\(item.loops)")
                        .font(.headline.bold())
                        .foregroundColor(colors.primary)
                    
                    Text(appEnv.language.localizedString("tasbih_loops"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(colors.foreground.opacity(0.4))
                        .textCase(.uppercase)
                }
                .frame(width: 40)
                
                Button {
                    if let idx = sequence.firstIndex(where: { $0.id == item.id }) {
                        sequence[idx].loops += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(colors.primary)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        // Direct move on the binding
        withAnimation {
            sequence.move(fromOffsets: source, toOffset: destination)
        }
    }
}
