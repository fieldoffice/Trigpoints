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

    var body: some Scene {
        WindowGroup {
            TopLevel()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
