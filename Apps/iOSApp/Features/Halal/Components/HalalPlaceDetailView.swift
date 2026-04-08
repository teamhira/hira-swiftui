//
//  HalalPlaceDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

/// Detailed view for a specific Halal place, showing its location, description, and facilities.
struct HalalPlaceDetailView: View {
    // MARK: - Dependencies
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    let place: HalalPlace
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - Header Visual Area
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(colors.primary.opacity(0.1))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 80))
                                    .foregroundColor(colors.primary.opacity(0.3))
                            )
                    }
                    .accessibilityHidden(true)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // MARK: - Place Identity Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(place.type)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(colors.primary.opacity(0.1))
                                    .foregroundColor(colors.primary)
                                    .cornerRadius(20)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                    Text(String(format: "%.1f", place.rating))
                                        .font(.headline.bold())
                                        .foregroundColor(colors.foreground)
                                }
                            }
                            
                            Text(place.name)
                                .font(.title.bold())
                                .foregroundColor(colors.foreground)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(colors.primary)
                                Text(place.address)
                                    .font(.subheadline)
                                    .foregroundColor(colors.foreground.opacity(0.7))
                            }
                        }
                        
                        // MARK: - Characteristics Grid
                        HStack(spacing: 16) {
                            StatItem(icon: "location.fill", label: appEnv.language.localizedString("mosque_stat_distance"), value: formattedDistance, colors: colors)
                            StatItem(icon: "person.2.fill", label: appEnv.language.localizedString("mosque_stat_capacity"), value: "\(place.capacity)", colors: colors)
                            StatItem(icon: "clock.fill", label: appEnv.language.localizedString("mosque_stat_status"), value: place.isOpen ? appEnv.language.localizedString("mosque_status_open") : appEnv.language.localizedString("mosque_status_closed"), colors: colors, isHighlight: place.isOpen)
                        }
                        
                        // MARK: - Description Area
                        VStack(alignment: .leading, spacing: 12) {
                            Text(appEnv.language.localizedString("halal_about_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            
                            Text(place.description)
                                .font(.body)
                                .foregroundColor(colors.foreground.opacity(0.7))
                                .lineSpacing(6)
                        }
                        
                        Spacer(minLength: 120) // Space for floating button
                    }
                    .padding(24)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // MARK: - Action Interface
            Button(action: openInMaps) {
                HStack(spacing: 12) {
                    Image(systemName: "map.fill")
                    Text(appEnv.language.localizedString("mosque_direct_button"))
                }
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(colors.primary)
                .cornerRadius(20)
                .shadow(color: colors.primary.opacity(0.4), radius: 15, x: 0, y: 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .accessibilityLabel(appEnv.language.localizedString("mosque_direct_button"))
            .accessibilityHint("Opens Apple Maps for directions to \(place.name)")
        }
        .background(colors.background)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.foreground)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Logic Helpers
    private var formattedDistance: String {
        if place.distance >= 1000 {
            return String(format: "%.1f km", Double(place.distance) / 1000.0)
        } else {
            return "\(place.distance) m"
        }
    }
    
    // MARK: - Interaction Handlers
    private func openInMaps() {
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let mapItem = MKMapItem(location: location, address: .init(fullAddress: place.address, shortAddress: place.name))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

// MARK: - Support Components

/// Individual statistic card for displaying place metadata.
private struct StatItem: View {
    let icon: String
    let label: String
    let value: String
    let colors: ThemeModel
    var isHighlight: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isHighlight ? .green : colors.primary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(colors.foreground.opacity(0.4))
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(colors.foreground)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(colors.foreground.opacity(0.04))
        .cornerRadius(20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}
