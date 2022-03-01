//
//  NearbyPointsList.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI
import CoreLocation

struct NearbyPointsList: View {
    @EnvironmentObject private var locationModel: AnyLocationModel
    @AppStorage("showGoodOnly") var showGoodOnly: Bool = false
    @State private var showSheet = false
    
    @FetchRequest var fetchRequest: FetchedResults<TrigPoint>
    
    init(filter: CLLocation?) {
        var predicate: NSPredicate? = nil
        if let location = filter {
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
            return fetchRequest.filter {
                !showGoodOnly || $0.cond == .good
            }.sorted {
                $0.location.distance(from: location) < $1.location.distance(from: location)
            }
        } else {
            return fetchRequest.filter {
                !showGoodOnly || $0.cond == .good
            }
        }
    }
    
    var categories: [String: [TrigPoint]] {
        Dictionary(
            grouping: orderedPoints,
            by: { $0.wrappedPointType.rawValue }
        )
    }
    
    var body: some View {
        if let location = locationModel.approximateLocation {
            List {
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    Section(key) {
                        ForEach(categories[key]!, id: \.self) { point in
                            NavigationLink {
                                DetailView(currentLocation: location, trigpoint: point)
                            } label: {
                                PointListItem(point: point, currentLocation: location)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showSheet = true
                        } label: {
                            Image(systemName: "eye")
                        }
                    }
                }
            }.sheet(isPresented: $showSheet) {
                ListFilters()
            }
            .navigationTitle("Nearby")
        } else {
            Spacer()
            Text("Acquiring location...")
            Spacer()
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
