//
//  HalalViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation
import MapKit
import CoreLocation
import SwiftUI
import AVFoundation

// MARK: - Models

/// Tab options for the Halal Finder feature.
public enum HalalTab: String, CaseIterable {
    case places = "Places"
    case food = "Food"
}

/// Represents a Halal-certified place with geographical and descriptive metadata.
public struct HalalPlace: Identifiable, Equatable, Hashable {
    public let id: UUID
    public let name: String
    public let address: String
    public var distance: Int
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
    
    public static func == (lhs: HalalPlace, rhs: HalalPlace) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// Represents a Halal-certified food product or ingredient.
public struct HalalFood: Identifiable, Equatable, Hashable {
    public let id: UUID
    public let name: String
    public let brand: String
    public let status: String // "Certified", "Pending", "Doubtful"
    public let imageName: String
    public let category: String
    
    public init(id: UUID = UUID(), name: String, brand: String, status: String, imageName: String, category: String) {
        self.id = id
        self.name = name
        self.brand = brand
        self.status = status
        self.imageName = imageName
        self.category = category
    }
    
    public static func == (lhs: HalalFood, rhs: HalalFood) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - ViewModel

/// ViewModel responsible for managing Halal Places and Food Scanning.
@Observable
public final class HalalViewModel: NSObject, CLLocationManagerDelegate {
    // MARK: - Navigation State
    public var selectedTab: HalalTab = .places
    
    // MARK: - Search State
    public var searchText: String = ""
    public var foodSearchText: String = ""
    
    // MARK: - Places State
    public var position: MapCameraPosition = .automatic
    public var selectedPlace: HalalPlace?
    public var userLocation: CLLocationCoordinate2D?
    public var currentCountry: String?
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// Filtered list of places based on search criteria and current detected country.
    public var filteredPlaces: [HalalPlace] {
        places.filter { place in
            (searchText.isEmpty || place.name.lowercased().contains(searchText.lowercased())) &&
            (currentCountry == nil || place.country == currentCountry)
        }
    }
    
    // MARK: - Food State
    public var foodItems: [HalalFood] = [
        HalalFood(name: "Instant Noodles", brand: "Indomie", status: "Certified", imageName: "food_1", category: "Snacks"),
        HalalFood(name: "Chocolate Bar", brand: "SilverQueen", status: "Certified", imageName: "food_2", category: "Sweets"),
        HalalFood(name: "Frozen Chicken", brand: "Belfoods", status: "Certified", imageName: "food_3", category: "Meats"),
        HalalFood(name: "Cheese Spread", brand: "Kraft", status: "Pending", imageName: "food_4", category: "Dairy")
    ]
    
    /// Filtered list of food items based on food search text.
    public var filteredFoodItems: [HalalFood] {
        foodItems.filter { item in
            foodSearchText.isEmpty || 
            item.name.lowercased().contains(foodSearchText.lowercased()) ||
            item.brand.lowercased().contains(foodSearchText.lowercased())
        }
    }
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Mock Place Data (Globally relevant, but can be filtered by distance)
    public var places: [HalalPlace] = [
        HalalPlace(
            name: "Al-Barakah Kitchen",
            address: "Jakarta Selatan",
            distance: 500,
            coordinate: CLLocationCoordinate2D(latitude: -6.2297, longitude: 106.8165),
            rating: 4.9,
            type: "Restaurant",
            isOpen: true,
            imageName: "halal_1",
            description: "Authentic Arabic and Middle Eastern cuisine with a modern twist.",
            capacity: 50,
            country: "ID"
        ),
        HalalPlace(
            name: "Restoran Seri Melayu",
            address: "Kuala Lumpur",
            distance: 2500,
            coordinate: CLLocationCoordinate2D(latitude: 3.1498, longitude: 101.7131),
            rating: 4.8,
            type: "Buffet",
            isOpen: true,
            imageName: "halal_4",
            description: "Famous Malay buffet restaurant.",
            capacity: 200,
            country: "MY"
        )
    ]
    
    // MARK: - Food State (Scanner & Capture)
    public var isScanning: Bool = false
    public var scannedResult: String?
    public var showPermissionAlert: Bool = false
    public var cameraStatus: AVAuthorizationStatus = .notDetermined
    
    // Modal & Search States
    public var isShowingBarcodeScanner: Bool = false
    public var isShowingFoodCapture: Bool = false
    public var capturedImage: UIImage?
    public var isSearchingFood: Bool = false
    public var foundFoodProduct: HalalFood?
    public var searchErrorMessage: String?
    
    // MARK: - Initialization
    public override init() {
        super.init()
        setupLocationManager()
        checkCameraStatus()
    }
    
    // MARK: - Camera & Scanning Logic
    
    /// Requests camera access and triggers completion.
    public func checkCameraPermissions(completion: @escaping (Bool) -> Void) {
        requestCameraAccess(completion: completion)
    }
    
    /// Simulation of a food product search based on a barcode or captured image.
    public func searchCapturedProduct() {
        isSearchingFood = true
        searchErrorMessage = nil
        foundFoodProduct = nil
        
        // Simulating network/AI delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isSearchingFood = false
            
            // For demo: 70% chance of success
            if Bool.random() || !self.foodItems.isEmpty {
                self.foundFoodProduct = self.foodItems.randomElement()
            } else {
                self.searchErrorMessage = "Product not found in Hira database."
            }
        }
    }
    
    /// Resets the capture state for a new attempts.
    public func resetCapture() {
        capturedImage = nil
        foundFoodProduct = nil
        searchErrorMessage = nil
        isSearchingFood = false
    }
    
    // MARK: - Initialization Helpers
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
    
    // MARK: - Camera Logic
    
    /// Checks the current camera authorization status.
    private func checkCameraStatus() {
        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    /// Requests camera access from the user if not already granted.
    public func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.checkCameraStatus()
                if !granted {
                    self.showPermissionAlert = true
                }
                completion(granted)
            }
        }
    }
    
    /// Starts the barcode scanning process.
    public func startScanning() {
        requestCameraAccess { granted in
            if granted {
                withAnimation {
                    self.isScanning = true
                    self.scannedResult = nil
                }
            }
        }
    }
    
    /// Captures a photo of the food for analysis or cataloging.
    public func captureFood() {
        requestCameraAccess { granted in
            if granted {
                // Placeholder for actual capture logic
                print("Capturing food...")
            }
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
    
    private func updateDistances(from userLocation: CLLocation) {
        places = places.map { place in
            let placeLoc = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            let distance = Int(userLocation.distance(from: placeLoc))
            var updated = place
            updated.distance = distance
            return updated
        }.sorted { $0.distance < $1.distance }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

