//
//  NearbyPoints.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI
import CoreData

struct NearbyPoints: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var locationModel: LocationModel
    @State private var loaded: Bool = false
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var points: FetchedResults<TrigPoint>
    
    var body: some View {
        NavigationView {
            if (loaded) {
                NearbyPointsList(filter: locationModel.approximateLocation)
                    .navigationTitle("Points")
            } else {
                Text("Loading data...")
            }
        }
        .onAppear {
            loaded = points.count != 0
            if !loaded {
                Task {
                    do {
                        try await PersistenceController.shared.loadJSONData(filename: "trig.json")
                        loaded = true
                    } catch {
                        print("failed \(error)")
                    }
                }
            }
        }
        // FFS: https://stackoverflow.com/questions/65316497/swiftui-navigationview-navigationbartitle-layoutconstraints-issue/65316745
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NearbyPoints_Previews: PreviewProvider {
    static var previews: some View {
        NearbyPoints()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LocationModel())
    }
}
