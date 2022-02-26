//
//  LocationRequiredWrapper.swift
//  Trigpoints
//
//  Created by Michael Dales on 26/02/2022.
//

import SwiftUI

struct LocationRequiredWrapper: View {
    @EnvironmentObject private var locationModel: LocationModel
    
    var body: some View {
        switch locationModel.authorizationStatus {
        case .notDetermined:
            Spacer()
            AnyView(RequestLocationView()).environmentObject(locationModel)
            Spacer()
        case .restricted:
            RequestErrorView(errorText: "Location use is restricted.")
        case .denied:
            RequestErrorView(errorText: "The app does not have location permissions, so can't show nearby trig points. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            NearbyPointsList(filter: locationModel.approximateLocation)
                .environmentObject(locationModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct LocationRequiredWrapper_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequiredWrapper()
    }
}
