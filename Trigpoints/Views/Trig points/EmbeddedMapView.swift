//
//  EmbeddedMapView.swift
//  Trigtastic
//
//  Created by Michael Dales on 06/02/2022.
//

import SwiftUI
import MapKit

struct EmbeddedMapView: View {
    var trigpoint: TrigPoint
    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [trigpoint]) { place in
            MapMarker(coordinate: place.coordinate)
        }
            .onAppear {
                setRegion(trigpoint.coordinate)
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
}

struct EmbeddedMapView_Previews: PreviewProvider {
    static var previews: some View {
        EmbeddedMapView(trigpoint: .preview)
    }
}
