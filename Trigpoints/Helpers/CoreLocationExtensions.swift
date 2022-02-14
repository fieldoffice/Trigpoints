//
//  CoreLocationExtensions.swift
//  Trigpoints
//
//  Created by Michael Dales on 14/02/2022.
//

import Foundation
import CoreLocation

// taken from https://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function

let earthRadius: Double = 6372456.7
let degToRad: Double = .pi / 180.0
let radToDeg: Double = 180.0 / .pi

func calcOffset(_ coord0: CLLocationCoordinate2D,
                _ coord1: CLLocationCoordinate2D) -> (Double, Double) {
    let lat0: Double = coord0.latitude * degToRad
    let lat1: Double = coord1.latitude * degToRad
    let lon0: Double = coord0.longitude * degToRad
    let lon1: Double = coord1.longitude * degToRad
    let dLat: Double = lat1 - lat0
    let dLon: Double = lon1 - lon0
    let y: Double = cos(lat1) * sin(dLon)
    let x: Double = cos(lat0) * sin(lat1) - sin(lat0) * cos(lat1) * cos(dLon)
    let t: Double = atan2(y, x)
    let bearing: Double = t * radToDeg

    let a: Double = pow(sin(dLat * 0.5), 2.0) + cos(lat0) * cos(lat1) * pow(sin(dLon * 0.5), 2.0)
    let c: Double = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));
    let distance: Double = c * earthRadius

    return (distance, bearing)
}

func translateCoord(_ coord: CLLocationCoordinate2D,
                    _ distance: Double,
                    _ bearing: Double) -> CLLocationCoordinate2D {
    let d: Double = distance / earthRadius
    let t: Double = bearing * degToRad

    let lat0: Double = coord.latitude * degToRad
    let lon0: Double = coord.longitude * degToRad
    let lat1: Double = asin(sin(lat0) * cos(d) + cos(lat0) * sin(d) * cos(t))
    let lon1: Double = lon0 + atan2(sin(t) * sin(d) * cos(lat0), cos(d) - sin(lat0) * sin(lat1))

    let lat: Double = lat1 * radToDeg
    let lon: Double = lon1 * radToDeg

    let c: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat,
                                                           longitude: lon)
    return c
}
