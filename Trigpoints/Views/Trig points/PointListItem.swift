//
//  PointListItem.swift
//  Trigtastic
//
//  Created by Michael Dales on 12/02/2022.
//

import SwiftUI
import CoreLocation
import MapKit

struct PointListItem: View {
    var point: TrigPoint
    var currentLocation: CLLocation?
    
    var body: some View {
        HStack {
            Text(point.name ??  "")
            Spacer()
            if let location = currentLocation {
                let formatter = MKDistanceFormatter()
                let prose = formatter.string(fromDistance: location.distance(from:point.location))
                Text(prose)
            }
        }
        .foregroundColor(point.cond == .good ? .primary : .secondary)
    }
}

struct PointListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PointListItem(
                point: .preview,
                currentLocation: CLLocation(latitude: 60.1, longitude: 0.10)
            )
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
