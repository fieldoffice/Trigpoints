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
    var formatter: MKDistanceFormatter
    
    init(point: TrigPoint, currentLocation: CLLocation?) {
        self.point = point
        self.currentLocation = currentLocation
        self.formatter = MKDistanceFormatter()
        self.formatter.unitStyle = .abbreviated
    }
    
    var visitCount: Int {
        point.visits?.count ?? 0
    }
    
    var body: some View {
        HStack {
            Text(point.name ??  "")
            if visitCount > 0 {
                Image(systemName: "checkmark")
            }
            Spacer()
            if let location = currentLocation {
                let prose = formatter.string(fromDistance: location.distance(from:point.location))
                Text(prose)
                let res = calcOffset(location.coordinate, point.coordinate)
                AngleIndicator(angle: res.1)
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
