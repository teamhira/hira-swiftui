//
//  MosqueMapView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

struct MosqueMapView: View {
    // MARK: - Properties
    @Binding var position: MapCameraPosition
    let mosques: [MosqueItem]
    @Binding var selectedMosque: MosqueItem?
    let colors: ThemeModel
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $position, selection: $selectedMosque) {
                // User Location
                UserAnnotation()
                
                // Mosque Markers
                ForEach(mosques) { mosque in
                    Marker(mosque.name, systemImage: "building.2.fill", coordinate: mosque.coordinate)
                        .tag(mosque)
                        .tint(colors.primary)
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            
            // MARK: - Overlay Controls
            Button {
                withAnimation {
                    position = .automatic
                }
            } label: {
                Image(systemName: "location.north.fill")
                    .padding(12)
                    .background(colors.background)
                    .clipShape(Circle())
                    .shadow(color: colors.foreground.opacity(0.1), radius: 8, x: 0, y: 4)
                    .foregroundColor(colors.primary)
            }
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .hiraCleanCard(colors: colors, radius: 32)
    }
}




