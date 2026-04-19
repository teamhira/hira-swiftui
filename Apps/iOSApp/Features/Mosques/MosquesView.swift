//
//  MosquesView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import MapKit

/// Main screen for finding nearby mosques with built-in navigation and information lookup.
struct MosquesView: View {
    // MARK: - Properties
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = MosquesViewModel()
    
    // UI State
    @State private var selectedDetailMosque: MosqueItem?
    @State private var isMapExpanded = false
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Map Header Area
            MosqueMapView(
                position: $viewModel.position,
                mosques: viewModel.filteredMosques,
                selectedMosque: $viewModel.selectedMosque,
                colors: colors
            )
            .frame(height: isMapExpanded ? nil : 180)
            .frame(maxHeight: isMapExpanded ? .infinity : 180)
            .padding(.horizontal, isMapExpanded ? 0 : 16)
            .padding(.top, isMapExpanded ? 0 : 8)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMapExpanded)
            
            // Exploration Section (Map must not be expanded)
            if !isMapExpanded {
                // MARK: - List Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 1. Search Field Card
                        MosqueFilterCard(searchText: $viewModel.searchText, colors: colors)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        // 2. Results Summary and List
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(appEnv.language.localizedString("mosque_result_title"))
                                    .font(.headline.bold())
                                    .foregroundColor(colors.foreground)
                                
                                Spacer()
                                
                                // Result count badge
                                Text("\(viewModel.filteredMosques.count) \(appEnv.language.localizedString("mosque_count_suffix"))")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(colors.primary.opacity(0.1))
                                    .foregroundColor(colors.primary)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 24)
                            
                            // 3. Mosque Card List
                            VStack(spacing: 0) {
                                ForEach(viewModel.filteredMosques) { mosque in
                                    MosqueListItem(
                                        mosque: mosque,
                                        colors: colors,
                                        onDirections: { openInMaps(mosque: mosque) },
                                        onTap: { selectedDetailMosque = mosque }
                                    )
                                    .padding(.horizontal, 24)
                                    .accessibilityLabel("\(mosque.name), \(mosque.isOpen ? "Open" : "Closed"), Distance \(mosque.distance) meters")
                                    .accessibilityHint("Tap to view details or use the direction button")
                                    
                                    if mosque != viewModel.filteredMosques.last {
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
        .background(colors.background.ignoresSafeArea())
        .navigationTitle(appEnv.language.localizedString("home_feature_mosques"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isMapExpanded.toggle()
                    }
                }) {
                    Image(systemName: isMapExpanded ? "list.bullet.below.rectangle" : "map.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isMapExpanded ? "Switch to list view" : "Expand map view")
            }
        }
        .sheet(item: $selectedDetailMosque) { mosque in
            NavigationStack {
                MosqueDetailView(mosque: mosque)
            }
        }
    }
    
    // MARK: - Navigation Helpers
    
    /// Launches the native Apple Maps app to provide directions to the specified mosque.
    private func openInMaps(mosque: MosqueItem) {
        let location = CLLocation(latitude: mosque.coordinate.latitude, longitude: mosque.coordinate.longitude)
        let mapItem = MKMapItem(location: location, address: .init(fullAddress: mosque.address, shortAddress: mosque.name))
        mapItem.name = mosque.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}




#Preview {
    NavigationStack {
        MosquesView()
            .environment(AppState())
    }
}
