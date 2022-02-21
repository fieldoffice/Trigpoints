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
    
    @State private var showVisitedSheet = false
    
    let kCollectionThreshold = 100.0
    
    let distanceFormatter = MKDistanceFormatter()
    let heightFormatter = NumberFormatter()

    var visitCount: Int {
        trigpoint.visits?.count ?? 0
    }
    
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
                        if visitCount > 0 {
                            NavigationLink {
                                VisitsList()
                            } label: {
                                if visitCount > 1 {
                                    Text("You have visited here \(trigpoint.visits?.count ?? 0) times")
                                } else if visitCount == 1 {
                                    Text("You visited here once!")
                                }
                            }
                        } else {
                            Text("You have not visited here yet!")
                        }
                        if let location = currentLocation {
                            if location.distance(from:trigpoint.location) < kCollectionThreshold {
                                Button {
                                    showVisitedSheet = true
                                } label: {
                                    Text("Mark as visited")
                                }.sheet(isPresented: $showVisitedSheet) {
                                    VisitedSheet(trigpoint: trigpoint)
                                }
                            }
                        }
                    }
                    Section {
                        if let location = currentLocation {
                            let prose = distanceFormatter.string(fromDistance: location.distance(from:trigpoint.location))
                            Text("Distance: \(prose)")
                        }
                        if trigpoint.height != 0 {
                            Text("Height: \(heightFormatter.string(from: NSNumber(value: trigpoint.height))!) meters")
                        }
                        Text("Condition: \(trigpoint.cond.rawValue)")
                        if trigpoint.wrappedPointType != .other {
                            Text("Type: \(trigpoint.wrappedPointType.rawValue)")
                        }
                        if trigpoint.wrappedCurrentUse != .unknown {
                            Text("Current usage: \(trigpoint.wrappedCurrentUse.rawValue)")
                        }
                        if trigpoint.wrappedHistoricUse != .unknown {
                            Text("Historic usage: \(trigpoint.wrappedHistoricUse.rawValue)")
                        }
                        if let identifier = trigpoint.identifier {
                            Text("ID: \(identifier)")
                        }
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            currentLocation: CLLocation(latitude: 60, longitude: 0.10),
            trigpoint: .preview
        )
    }
}
