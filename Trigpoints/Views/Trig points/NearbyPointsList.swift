//
//  NearbyPointsList.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI
import CoreLocation

struct NearbyPointsList: View {
    @EnvironmentObject private var locationModel: LocationModel
    
    @FetchRequest var fetchRequest: FetchedResults<TrigPoint>
    
    init(filter: CLLocation?) {
        var predicate: NSPredicate? = nil
        if let location = filter {
            print("\(location)")
            predicate = NSPredicate(
                format: "latitude > %f AND latitude < %f AND longitude > %f AND longitude < %f",
                location.coordinate.latitude - 0.1,
                location.coordinate.latitude + 0.1,
                location.coordinate.longitude - 0.1,
                location.coordinate.longitude + 0.1
            )
        }
        _fetchRequest = FetchRequest<TrigPoint>(
            sortDescriptors: [],
            predicate: predicate
        )
    }
    
    var orderedPoints: [TrigPoint] {
        if let location = locationModel.approximateLocation {
            return fetchRequest.sorted {
                $0.location.distance(from: location) < $1.location.distance(from: location)
            }
        } else {
            return fetchRequest.sorted {
                $0.height < $1.height
            }
        }
    }
    
    var body: some View {
        if let location = locationModel.approximateLocation {
            List(orderedPoints, id: \.self) { point in
                NavigationLink {
                    DetailView(trigpoint: point)
                } label: {
                    PointListItem(point: point, currentLocation: location)
                }
            }
        } else {
            Text("Acquiring location...")
        }
    }
}

struct NearbyPointsList_Previews: PreviewProvider {
    static var previews: some View {
        NearbyPointsList(filter: CLLocation(latitude: 60.0, longitude: 0.1))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LocationModel())
    }
}
