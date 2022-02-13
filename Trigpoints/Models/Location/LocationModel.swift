//
//  LocationModel.swift
//  Trigtastic
//
//  Created by Michael Dales on 06/02/2022.
//

import Foundation
import CoreLocation

class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    
    let MovementThreshold = 30.0
    
    // This only updates if we've moved a reasonable distance, to try
    // reduce UI updates as the GPS bounces
    @Published var approximateLocation: CLLocation?
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // To try reduce UI spam, we will tend to observe approximateLocation for high level lists
        // and only observce lastSeenLocation for things that really need detailed updates
        if let location = locations.first {
            if let last = approximateLocation {
                if location.distance(from: last) > MovementThreshold {
                    approximateLocation = location
                }
            } else {
                // need an initial value
                approximateLocation = location
            }
        }
        lastSeenLocation = locations.first
    }
}
