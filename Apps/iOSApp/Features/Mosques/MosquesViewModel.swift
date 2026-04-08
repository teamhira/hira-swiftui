//
//  MosquesViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation
import MapKit
import CoreLocation
import SwiftUI

/// ViewModel responsible for Mosque data management and real-time distance calculations.
@Observable
public final class MosquesViewModel: NSObject, CLLocationManagerDelegate {
    // MARK: - Properties
    public var searchText: String = ""
    public var position: MapCameraPosition = .automatic
    public var selectedMosque: MosqueItem?
    public var userLocation: CLLocationCoordinate2D?
    public var currentCountry: String?
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Computed Properties
    
    /// Filtered list of mosques based on search criteria and detected country.
    public var filteredMosques: [MosqueItem] {
        mosques.filter { mosque in
            (searchText.isEmpty || mosque.name.lowercased().contains(searchText.lowercased())) &&
            (currentCountry == nil || mosque.country == currentCountry)
        }
    }
    
    // MARK: - Mock Data
    public var mosques: [MosqueItem] = [
        MosqueItem(
            name: "Masjid Istiqlal",
            address: "Jakarta Pusat",
            distance: 800,
            coordinate: CLLocationCoordinate2D(latitude: -6.1702, longitude: 106.8314),
            rating: 4.9,
            type: "Masjid Agung",
            isOpen: true,
            imageName: "istiqlal_image",
            description: "Masjid terbesar di Asia Tenggara yang merupakan kebanggaan Indonesia dengan arsitektur modern yang megah.",
            capacity: 200000,
            country: "ID"
        ),
        MosqueItem(
            name: "Masjid Agung Sunda Kelapa",
            address: "Menteng, Jakarta Pusat",
            distance: 1200,
            coordinate: CLLocationCoordinate2D(latitude: -6.1994, longitude: 106.8326),
            rating: 4.8,
            type: "Masjid Besar",
            isOpen: true,
            imageName: "sunda_kelapa_image",
            description: "Masjid bersejarah di Menteng yang unik karena tidak memiliki kubah dan sangat populer untuk kegiatan dakwah.",
            capacity: 5000,
            country: "ID"
        ),
        MosqueItem(
            name: "Masjid Negara",
            address: "Kuala Lumpur",
            distance: 1500,
            coordinate: CLLocationCoordinate2D(latitude: 3.1418, longitude: 101.6917),
            rating: 4.8,
            type: "Masjid Negara",
            isOpen: true,
            imageName: "national_mosque_ms",
            description: "The National Mosque of Malaysia is a mosque in Kuala Lumpur. It has a capacity of 15,000 people and is situated among 13 acres of gardens.",
            capacity: 15000,
            country: "MY"
        )
    ]
    
    // MARK: - Initialization
    public override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Location Delegate
    @available(iOS, deprecated: 26.0, message: "Use modern MapKit geocoding when stable")
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        updateDistances(from: location)
        detectCountry(from: location)
    }
    
    /// Detects the current country ISO code using a fallback geocoder.
    @available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
    private func detectCountry(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let iso = placemarks?.first?.isoCountryCode {
                DispatchQueue.main.async {
                    self.currentCountry = iso
                }
            }
        }
    }
    
    /// Updates the distance property for all mosques based on the new user location.
    private func updateDistances(from userLocation: CLLocation) {
        mosques = mosques.map { mosque in
            let mosqueLocation = CLLocation(latitude: mosque.coordinate.latitude, longitude: mosque.coordinate.longitude)
            let distanceInMeters = userLocation.distance(from: mosqueLocation)
            
            // Re-create the item with updated distance while preserving other metadata
            return MosqueItem(
                id: mosque.id,
                name: mosque.name,
                address: mosque.address,
                distance: Int(distanceInMeters),
                coordinate: mosque.coordinate,
                rating: mosque.rating,
                type: mosque.type,
                isOpen: mosque.isOpen,
                imageName: mosque.imageName,
                description: mosque.description,
                capacity: mosque.capacity,
                country: mosque.country
            )
        }.sorted { $0.distance < $1.distance }
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Models

/// Represents a Mosque location with relevant spiritual and facility metadata.
public struct MosqueItem: Identifiable, Equatable, Hashable {
    public let id: UUID
    public let name: String
    public let address: String
    public let distance: Int
    public let coordinate: CLLocationCoordinate2D
    public let rating: Double
    public let type: String
    public let isOpen: Bool
    public let imageName: String
    public let description: String
    public let capacity: Int
    public let country: String
    
    public init(
        id: UUID = UUID(), 
        name: String, 
        address: String, 
        distance: Int, 
        coordinate: CLLocationCoordinate2D, 
        rating: Double, 
        type: String, 
        isOpen: Bool,
        imageName: String = "",
        description: String = "",
        capacity: Int = 0,
        country: String = "ID"
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.distance = distance
        self.coordinate = coordinate
        self.rating = rating
        self.type = type
        self.isOpen = isOpen
        self.imageName = imageName
        self.description = description
        self.capacity = capacity
        self.country = country
    }
    
    public static func == (lhs: MosqueItem, rhs: MosqueItem) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

