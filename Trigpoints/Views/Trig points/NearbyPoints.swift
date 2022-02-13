//
//  NearbyPoints.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI

struct NearbyPoints: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var locationModel: LocationModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TrigPoint.name, ascending: true)],
        animation: .default)
    private var points: FetchedResults<TrigPoint>
    
    var orderedPoints: [TrigPoint] {
        if let location = locationModel.approximateLocation {
            return points.sorted {
                $0.location.distance(from: location) < $1.location.distance(from: location)
            }
        } else {
            return points.sorted {
                $0.height < $1.height
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orderedPoints) { point in
                    NavigationLink {
                        DetailView(trigpoint: point)
                    } label: {
                        PointListItem(point: point, currentLocation: locationModel.approximateLocation)
                    }
                }
            }
            .navigationTitle("Points")
        }
        // FFS: https://stackoverflow.com/questions/65316497/swiftui-navigationview-navigationbartitle-layoutconstraints-issue/65316745
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if points.count == 0 {
                Task {
                    do {
                        try await PersistenceController.shared.loadJSONData(filename: "smalltrig.json")
                    } catch {
                        print("fialed \(error)")
                    }
                }
            }
        }
    }
}

struct NearbyPoints_Previews: PreviewProvider {
    static var previews: some View {
        NearbyPoints()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LocationModel())
    }
}
