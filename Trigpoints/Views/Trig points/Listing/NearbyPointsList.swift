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
    @EnvironmentObject private var nearbyPointsModel: NearbyPointsModel

    @AppStorage("showGoodOnly") var showGoodOnly: Bool = false
    @State private var showSheet = false

    var categories: [String: [TrigPoint]] {
        Dictionary(
            grouping: nearbyPointsModel.nearbyPoints,
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
        NearbyPointsList()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LocationModel())
    }
}
