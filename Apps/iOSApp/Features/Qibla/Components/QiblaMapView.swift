//
//  QiblaMapView.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import MapKit

struct QiblaMapView: View {
    // MARK: - Properties
    let userLocation: CLLocationCoordinate2D?
    let kaabaCoordinate = CLLocationCoordinate2D(latitude: 21.4225, longitude: 39.8262)
    
    @Environment(\.appEnvironment) private var appEnv
    
    // MARK: - State
    @State private var position: MapCameraPosition = .automatic
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        Map(position: $position) {
            // 1. Kaaba Target
            Annotation(coordinate: kaabaCoordinate) {
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(colors.primary)
                            .frame(width: 36, height: 36)
                            .shadow(color: colors.primary.opacity(0.4), radius: 10)
                        
                        Image(systemName: "hand.point.up.braille.fill") // Kaaba icon
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    Text(appEnv.language.localizedString("qibla_kaaba_label"))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(colors.foreground)
                        .padding(4)
                        .background(colors.background.opacity(0.8))
                        .clipShape(Capsule())
                }
                .accessibilityLabel(appEnv.language.localizedString("qibla_kaaba_label"))
            } label: {
                Text(appEnv.language.localizedString("qibla_mecca_label"))
            }
            
            // 2. User Point
            if let userLocation = userLocation {
                // Pulse effect for user
                Annotation(coordinate: userLocation) {
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.15))
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .fill(.blue)
                            .frame(width: 14, height: 14)
                            .overlay(Circle().stroke(.white, lineWidth: 2))
                    }
                    .accessibilityLabel(appEnv.language.localizedString("qibla_current_location_label"))
                } label: {
                    Text(appEnv.language.localizedString("qibla_current_location_label"))
                }
                
                // 3. Direct line to Kaaba (The Path)
                MapPolyline(coordinates: [userLocation, kaabaCoordinate])
                    .stroke(colors.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [5, 10])) // Dotted line for journey
            }
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .hiraCleanCard(colors: colors, radius: 32)
        .onAppear {
            updatePosition()
        }
        .onChange(of: userLocation?.latitude) { _, _ in
            updatePosition()
        }
    }
    
    // MARK: - Camera Control
    private func updatePosition() {
        guard let user = userLocation else { 
            // Default center if no user location (e.g., center on Kaaba)
            withAnimation(.spring()) {
                position = .region(MKCoordinateRegion(
                    center: kaabaCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                ))
            }
            return 
        }
        
        let coordinates = [user, kaabaCoordinate]
        var mapRect = coordinates.reduce(MKMapRect.null) { rect, coord in
            let point = MKMapPoint(coord)
            return rect.union(MKMapRect(origin: point, size: MKMapSize(width: 0, height: 0)))
        }
        
        // Add padding to mapRect
        let padding = mapRect.size.width * 0.2
        mapRect = mapRect.insetBy(dx: -padding, dy: -padding)
        
        // Ensure rect is valid before setting position
        if !mapRect.isNull {
            withAnimation(.spring()) {
                position = .rect(mapRect)
            }
        }
    }
}
