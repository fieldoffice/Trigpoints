//
//  TrigpointsApp.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI

@main
struct TrigpointsApp: App {
    let persistenceController = PersistenceController.shared
    let locationModel: AnyLocationModel
    let nearbyPointsModel: NearbyPointsModel

    init() {
        self.locationModel = AnyLocationModel()
        self.nearbyPointsModel = NearbyPointsModel(locationModel: self.locationModel)
    }

    var body: some Scene {
        WindowGroup {
            TopLevel()
                .environmentObject(locationModel)
                .environmentObject(nearbyPointsModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
