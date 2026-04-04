//
//  QiblaViewModel.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import SwiftUI
import CoreLocation
import Observation

@Observable
public class QiblaViewModel: NSObject, CLLocationManagerDelegate {
    // MARK: - Published Properties
    public var heading: Double = 0
    public var qiblaDirection: Double = 0
    public var distanceToMecca: Double = 0
    public var userLocation: CLLocationCoordinate2D?
    public var selectedStyle: QiblaCompassStyle = QiblaCompassStyle.availableStyles[0]
    public var isFacingMecca: Bool = false
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private let kaabaCoordinate = CLLocationCoordinate2D(latitude: 21.4225, longitude: 39.8262)
    
    // MARK: - Initialization
    public override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 
        locationManager.headingFilter = 0.5 // High sensitivity for compass
        
        authorizationStatus = locationManager.authorizationStatus
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            startTracking()
        }
    }
    
    // MARK: - Permissions & Tracking
    public func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    // MARK: - Navigation Calculations
    
    /// Qibla Bearing calculation based on Great Circle distance
    private func calculateQibla(from: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lon1 = from.longitude * .pi / 180
        let lat2 = kaabaCoordinate.latitude * .pi / 180
        let lon2 = kaabaCoordinate.longitude * .pi / 180
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        var qibla = atan2(y, x) * 180 / .pi
        qibla = (qibla + 360).truncatingRemainder(dividingBy: 360)
        
        return qibla
    }
    
    // MARK: - Delegate Methods
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        debugPrint("User Location updated: \(location.coordinate)")
        userLocation = location.coordinate
        qiblaDirection = calculateQibla(from: location.coordinate)
        
        // Calculate distance
        let meccaLocation = CLLocation(latitude: kaabaCoordinate.latitude, longitude: kaabaCoordinate.longitude)
        distanceToMecca = location.distance(from: meccaLocation) / 1000 // Convert to km
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Use trueHeading if available (accurate to north), else magnetic
        let currentHeading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            heading = currentHeading
            
            // Tolerance ±3 degrees for Mecca lock-on
            let diff = abs(heading - qiblaDirection)
            let normalizedDiff = min(diff, 360 - diff)
            isFacingMecca = normalizedDiff < 3.0
            
            // Haptic nudge when locking on Mecca
            if isFacingMecca {
                // UI feedback elsewhere should trigger haptic if needed
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Location Manager error: \(error.localizedDescription)")
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startTracking()
        }
    }
}
