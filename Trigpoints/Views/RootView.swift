//
//  RootView.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI
import CoreData

struct RootView: View {
    @StateObject var locationModel = LocationModel()
    
    var body: some View {
        switch locationModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView()).environmentObject(locationModel)
        case .restricted:
            RequestErrorView(errorText: "Location use is restricted.")
        case .denied:
            RequestErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            TopLevel()
                .environmentObject(locationModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
