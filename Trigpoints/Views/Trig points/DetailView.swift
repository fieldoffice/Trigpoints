//
//  DetailView.swift
//  Trigtastic
//
//  Created by Michael Dales on 06/02/2022.
//

import SwiftUI
import CoreLocation
import MapKit

struct DetailView: View {
    var currentLocation: CLLocation?
    var trigpoint: TrigPoint
    
    let distanceFormatter = MKDistanceFormatter()
    let heightFormatter = NumberFormatter()
    
    var body: some View {
        GeometryReader { frame in
            VStack {
                EmbeddedMapView(trigpoint: trigpoint)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: frame.size.height / 2)
                Text("\(trigpoint.latitude), \(trigpoint.longitude)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                List {
                    Section {
                        
                        if let location = currentLocation {
                            let prose = distanceFormatter.string(fromDistance: location.distance(from:trigpoint.location))
                            Text("Distance: \(prose)")
                        }
                        Text("Height: \(heightFormatter.string(from: NSNumber(value: trigpoint.height))!) meters")
                        Text("Condition: \(trigpoint.cond.rawValue)")
//                        Text("ID: \(trigpoint.id)")
                    }
                    .headerProminence(.increased)
                    Section("open with") {
                        HStack {
                            Button {
                                let placemark = MKPlacemark(coordinate: trigpoint.coordinate)
                                let mapitem = MKMapItem(placemark: placemark)
                                mapitem.openInMaps(launchOptions: [
                                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: trigpoint.coordinate)
                                ])
                            } label: {
                                LabelledButton(label: "Maps", imageName: "map.fill")
                            }
                            
                            if let link = trigpoint.link, let url = URL(string: link) {
                                Button {
                                   UIApplication.shared.open(url)
                                } label: {
                                    LabelledButton(label: "Browser", imageName: "safari.fill")
                                }
                            }
                        }
                    }
                }.listStyle(.insetGrouped)
                
            }
        }
        .navigationTitle(trigpoint.name ?? "")
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(currentLocation: CLLocation(latitude: 60, longitude: 0.10), trigpoint: TrigPointsModel(filename: "smalltrig.json").points[0])
//    }
//}
