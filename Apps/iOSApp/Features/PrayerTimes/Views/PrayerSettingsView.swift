//
//  PrayerSettingsView.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import SwiftUI

@available(iOS, deprecated: 26.0)
struct PrayerSettingsView: View {
    @Bindable var viewModel: PrayerTimesViewModel
    let onDone: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    pickerRow(title: "Metode Perhitungan", selection: Binding(
                        get: { viewModel.selectedMethod },
                        set: { viewModel.updateMethod($0) }
                    ), options: viewModel.methods.keys.sorted(), labels: viewModel.methods)
                    
                    pickerRow(title: "Madhab", selection: Binding(
                        get: { viewModel.selectedMadhab },
                        set: { viewModel.updateMadhab($0) }
                    ), options: ["Shafi", "Hanafi"], labels: ["Shafi": "Syafi'i (Standar)", "Hanafi": "Hanafi"])
                } header: {
                    Text("Pengaturan Waktu Sholat")
                } footer: {
                    Text(viewModel.prayerResponse?.islamicInfo?.note ?? "")
                }
            }
            .navigationTitle("Pengaturan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Selesai") { onDone() }
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    @ViewBuilder
    private func pickerRow(title: String, selection: Binding<String>, options: [String], labels: [String: Any]) -> some View {
        Picker(title, selection: selection) {
            ForEach(options, id: \.self) { key in
                if let method = labels[key] as? CalculationMethodModel {
                    Text(method.name).tag(key)
                } else if let label = labels[key] as? String {
                    Text(label).tag(key)
                } else {
                    Text(key).tag(key)
                }
            }
        }
    }
}
