//
//  LocationModel.swift
//  Trigtastic
//
//  Created by Michael Dales on 06/02/2022.
//

import Foundation
import CoreLocation
import Combine

class AnyLocationModel: ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var approximateLocation: CLLocation?
    
    private let locationModel: LocationModel
    var cancellables = Set<AnyCancellable>()
    
    init() {
        locationModel = LocationModel()
        locationModel.$approximateLocation.sink(receiveValue: {self.approximateLocation = $0}).store(in: &cancellables)
        locationModel.$authorizationStatus.sink(receiveValue: {self.authorizationStatus = $0}).store(in: &cancellables)
    }
    
    func requestPermission() {
        locationModel.requestPermission()
    }
}

class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    // This only updates if we've moved a reasonable distance, to try
    // reduce UI updates as the GPS bounces
    @Published var approximateLocation: CLLocation?
    
    let kMovementThreshold = 30.0
    
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
                if location.distance(from: last) > kMovementThreshold {
                    approximateLocation = location
                }
            } else {
                // need an initial value
                approximateLocation = location
            }
        }
    }
}
