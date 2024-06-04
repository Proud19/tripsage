//
//  LocationManager.swift
//  tripsage
//
//  Created by Proud Mpala on 5/31/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    
    @Published var location: CLLocation?
    private var timer: Timer?
    private let updateInterval: TimeInterval = 60.0 // Update interval in seconds
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingLocation() {
        // Start the timer to update location at regular intervals
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.locationManager.startUpdatingLocation()
            
            // Stop location updates after a short delay to save battery
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Adjust the delay as needed
                self?.locationManager.stopUpdatingLocation()
            }
        }
        timer?.fire() // Start immediately
    }
    
    func stopUpdatingLocation() {
        // Invalidate the timer and stop location updates
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            // Send location to backend
            NetworkManager.shared.updateLocation(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error.localizedDescription)")
    }
}
