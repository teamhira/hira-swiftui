//
//  HalalPlacesTabView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

/// Sub-view for the Places tab in Halal Finder.
public struct HalalPlacesTabView: View {
    // MARK: - Properties
    @Bindable var viewModel: HalalViewModel
    @Binding var isMapExpanded: Bool
    @Binding var selectedDetailPlace: HalalPlace?
    let colors: ThemeModel
    let appEnv: AppEnvironment
    
    // MARK: - Body
    public var body: some View {
        VStack(spacing: 0) {
            // Interactive Map Header
            HalalPlaceMapView(
                position: $viewModel.position,
                places: viewModel.filteredPlaces,
                selectedPlace: $viewModel.selectedPlace,
                colors: colors
            )
            .frame(height: isMapExpanded ? nil : 180)
            .frame(maxHeight: isMapExpanded ? .infinity : 180)
            .padding(.horizontal, isMapExpanded ? 0 : 16)
            .padding(.top, isMapExpanded ? 0 : 8)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMapExpanded)
            
            // Exploration Content
            if !isMapExpanded {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 1. Search & Filtering Card
                        HalalPlaceFilterCard(searchText: $viewModel.searchText, colors: colors)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        // 2. Results Discovery List
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(appEnv.language.localizedString("halal_nearby_title"))
                                    .font(.headline.bold())
                                    .foregroundColor(colors.foreground)
                                
                                Spacer()
                                
                                Text("\(viewModel.filteredPlaces.count) Places")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(colors.primary.opacity(0.1))
                                    .foregroundColor(colors.primary)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                ForEach(viewModel.filteredPlaces) { place in
                                    HalalPlaceListItem(
                                        place: place,
                                        colors: colors,
                                        onDirections: { openInMaps(place: place) },
                                        onTap: { selectedDetailPlace = place }
                                    )
                                    .padding(.horizontal, 24)
                                    
                                    if place != viewModel.filteredPlaces.last {
                                        Divider()
                                            .padding(.leading, 72)
                                            .padding(.trailing, 24)
                                            .opacity(0.3)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Navigation Helpers
    private func openInMaps(place: HalalPlace) {
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let mapItem = MKMapItem(location: location, address: .init(fullAddress: place.address, shortAddress: place.name))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
