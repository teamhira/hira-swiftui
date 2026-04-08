//
//  HalalPlaceMapView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

/// Interactive map component for visually exploring Halal places.
struct HalalPlaceMapView: View {
    // MARK: - Properties
    @Binding var position: MapCameraPosition
    let places: [HalalPlace]
    @Binding var selectedPlace: HalalPlace?
    let colors: ThemeModel
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // MARK: - Interactive Map Layer
            Map(position: $position, selection: $selectedPlace) {
                UserAnnotation()
                
                ForEach(places) { place in
                    Marker(place.name, systemImage: "fork.knife", coordinate: place.coordinate)
                        .tag(place)
                        .tint(colors.primary)
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            
            // MARK: - Navigation Control Overlay
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
