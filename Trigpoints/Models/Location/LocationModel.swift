//
//  LocationModel.swift
//  Trigtastic
//
//  Created by Michael Dales on 06/02/2022.
//

import Foundation
import CoreLocation
import Combine

protocol AbstractLocationModel {
    
    var approximateLocationPublisher: Published<CLLocation?>.Publisher { get }
    
    var authorizationStatusPublisher: Published<CLAuthorizationStatus>.Publisher { get }
    
    func requestPermission()
}

// This is a work around for two limitations in SwiftUI for UI test automation:
//   1: You can't use protocols for StateObjects or for @Published methods, so this
//      class is providing an abstraction layer for that.
//   2: You can't provide constructors to StateObjects, which is why you need to switch
//      between the mock and real objects here, rather than taking locationModel as a
//      parameter.
// It's all a bit icky, but so far I've not seen a better way to enable me to do UI
// testing when I have location dependancies for my data.

let kUITestingFlag = "-isUItesting"

class AnyLocationModel: ObservableObject {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var approximateLocation: CLLocation?
    
    private let locationModel: AbstractLocationModel
    var cancellables = Set<AnyCancellable>()
    
    init() {
        locationModel = ProcessInfo.processInfo.arguments.contains(kUITestingFlag) ? MockLocationModel() : LocationModel()
        locationModel.approximateLocationPublisher.sink(receiveValue: {self.approximateLocation = $0}).store(in: &cancellables)
        locationModel.authorizationStatusPublisher.sink(receiveValue: {self.authorizationStatus = $0}).store(in: &cancellables)
    }
    
    func requestPermission() {
        locationModel.requestPermission()
    }
}

class MockLocationModel: ObservableObject, AbstractLocationModel {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    var authorizationStatusPublisher: Published<CLAuthorizationStatus>.Publisher {
        return $authorizationStatus
    }
    
    // This only updates if we've moved a reasonable distance, to try
    // reduce UI updates as the GPS bounces
    @Published private(set) var approximateLocation: CLLocation?
    var approximateLocationPublisher: Published<CLLocation?>.Publisher {
        return $approximateLocation
    }
    
    init() {
        authorizationStatus = .authorizedWhenInUse
        approximateLocation = CLLocation(latitude: 55.8, longitude: -4.2)
    }
    
    func requestPermission() {
    }
}

class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate, AbstractLocationModel {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    var authorizationStatusPublisher: Published<CLAuthorizationStatus>.Publisher {
        return $authorizationStatus
    }
    
    // This only updates if we've moved a reasonable distance, to try
    // reduce UI updates as the GPS bounces
    @Published private(set) var approximateLocation: CLLocation?
    var approximateLocationPublisher: Published<CLLocation?>.Publisher {
        return $approximateLocation
    }
    
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
