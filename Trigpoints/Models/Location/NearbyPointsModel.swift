//
//  NearbyPointsModel.swift
//  Trigpoints
//
//  Created by Michael Dales on 07/06/2022.
//

import Foundation
import Combine
import CoreData
import SwiftUI

extension UserDefaults {
    @objc var showGoodOnly: Bool {
        get {
            return bool(forKey: "showGoodOnly")
        }
        set {
            set(newValue, forKey: "showGoodOnly")
        }
    }
}

class NearbyPointsModel: ObservableObject {

    @Published private(set) var nearbyPoints: [TrigPoint]

    private let dispatchQ = DispatchQueue(label: "updates.nearbypoints.digitalflapjack.com")
    private let locationModel: AnyLocationModel
    private var cancellables = Set<AnyCancellable>()

    init(locationModel: AnyLocationModel) {
        self.locationModel = locationModel
        self.nearbyPoints = []

        Publishers.CombineLatest(locationModel.approximateLocationPublisher, UserDefaults.standard.publisher(for: \.showGoodOnly))
            .receive(on: dispatchQ)
            .sink(receiveValue: { location, showGoodOnly in
                guard let location = location else {
                    return
                }
                var predicates: [NSPredicate] = []
                if showGoodOnly {
                    let predicate = NSPredicate(format: "condition == %@", TrigPoint.Condition.good.rawValue)
                    predicates.insert(predicate, at: 0)
                }
                let locationPredicate = NSPredicate(
                    format: "latitude > %f AND latitude < %f AND longitude > %f AND longitude < %f",
                    location.coordinate.latitude - 0.1,
                    location.coordinate.latitude + 0.1,
                    location.coordinate.longitude - 0.1,
                    location.coordinate.longitude + 0.1
                )
                predicates.insert(locationPredicate, at: predicates.endIndex)
                let fetchRequest = TrigPoint.fetchRequest()
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

                let newTaskContext = PersistenceController.shared.container.viewContext
                do {
                    let result = try newTaskContext.fetch(fetchRequest)

                    // sort the answers too
                    let sortedResult = result.sorted {
                        $0.location.distance(from: location) < $1.location.distance(from: location)
                    }
                    DispatchQueue.main.async {
                        // this will trigger UI updates, so push the update to mainQ
                        self.nearbyPoints = sortedResult
                    }
                } catch {
                    print("Failed to fetch points: \(error)")
                }
            })
            .store(in: &cancellables)
    }
}
