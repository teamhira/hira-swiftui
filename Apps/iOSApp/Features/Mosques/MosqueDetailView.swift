//
//  MosqueDetailView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

struct MosqueDetailView: View {
    // MARK: - Dependencies
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    let mosque: MosqueItem
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - Header Image
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(colors.primary.opacity(0.1))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(colors.primary.opacity(0.3))
                            )
                    }
                    .accessibilityHidden(true)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // MARK: - Information Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(mosque.type)
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
                                    Text(String(format: "%.1f", mosque.rating))
                                        .font(.headline.bold())
                                        .foregroundColor(colors.foreground)
                                }
                            }
                            
                            Text(mosque.name)
                                .font(.title.bold())
                                .foregroundColor(colors.foreground)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(colors.primary)
                                Text(mosque.address)
                                    .font(.subheadline)
                                    .foregroundColor(colors.foreground.opacity(0.7))
                            }
                        }
                        
                        // MARK: - Statistics Grid
                        HStack(spacing: 16) {
                            StatItem(icon: "location.fill", label: appEnv.language.localizedString("mosque_stat_distance"), value: formattedDistance, colors: colors)
                            StatItem(icon: "person.2.fill", label: appEnv.language.localizedString("mosque_stat_capacity"), value: "\(mosque.capacity)", colors: colors)
                            StatItem(icon: "clock.fill", label: appEnv.language.localizedString("mosque_stat_status"), value: mosque.isOpen ? appEnv.language.localizedString("mosque_status_open") : appEnv.language.localizedString("mosque_status_closed"), colors: colors, isHighlight: mosque.isOpen)
                        }
                        
                        // MARK: - About Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(appEnv.language.localizedString("mosque_about_title"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            
                            Text(mosque.description)
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
            
            // MARK: - Floating Bottom Action
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
            .accessibilityHint("Opens Apple Maps for directions to \(mosque.name)")
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
    
    // MARK: - Computed Properties
    private var formattedDistance: String {
        if mosque.distance >= 1000 {
            return String(format: "%.1f km", Double(mosque.distance) / 1000.0)
        } else {
            return "\(mosque.distance) m"
        }
    }
    
    // MARK: - Actions
    private func openInMaps() {
        let location = CLLocation(latitude: mosque.coordinate.latitude, longitude: mosque.coordinate.longitude)
        let mapItem = MKMapItem(location: location, address: .init(fullAddress: mosque.address, shortAddress: mosque.name))
        mapItem.name = mosque.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

// MARK: - Subviews
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


