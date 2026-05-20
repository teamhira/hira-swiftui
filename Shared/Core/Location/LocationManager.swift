//
//  LocationManager.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import CoreLocation
import Combine

@available(iOS, deprecated: 26.0, message: "Using fallback until MKReverseGeocodingRequest is stable")
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    private let manager = CLLocationManager()
    
    @Published public var location: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var cityName: String = "Jakarta" // Default
    
    public override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        self.authorizationStatus = manager.authorizationStatus
    }
    
    public func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        // Reverse geocode to get city name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let city = placemarks?.first?.locality {
                DispatchQueue.main.async {
                    self?.cityName = city
                }
            }
        }
        
        manager.stopUpdatingLocation()
    }
}
