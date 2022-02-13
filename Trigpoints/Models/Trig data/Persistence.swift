//
//  Persistence.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import CoreData
import CoreLocation

enum TrigPointError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case creationError
    case batchInsertError
    case batchDeleteError
    case persistentHistoryChangeError
    case unexpectedError(error: Error)
}

extension TrigPointError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongDataFormat(let error):
            return NSLocalizedString("Could not digest the fetched data. \(error.localizedDescription)", comment: "")
        case .missingData:
            return NSLocalizedString("Found and will discard a quake missing a valid code, magnitude, place, or time.", comment: "")
        case .creationError:
            return NSLocalizedString("Failed to create a new Quake object.", comment: "")
        case .batchInsertError:
            return NSLocalizedString("Failed to execute a batch insert request.", comment: "")
        case .batchDeleteError:
            return NSLocalizedString("Failed to execute a batch delete request.", comment: "")
        case .persistentHistoryChangeError:
            return NSLocalizedString("Failed to execute a persistent history change request.", comment: "")
        case .unexpectedError(let error):
            return NSLocalizedString("Received unexpected error. \(error.localizedDescription)", comment: "")
        }
    }
}

extension TrigPointError: Identifiable {
    var id: String? {
        errorDescription
    }
}


struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Visit(context: viewContext)
//            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Trigpoints")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func loadJSONData(filename: String) async throws {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle")
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle: \(error)")
        }
        do {
            let decoder = JSONDecoder()
            let raw = try decoder.decode([TrigPointJSON].self, from: data)
            try await importTrigPoints(from: raw)
        } catch {
            fatalError("Couldn't parse \(filename) as \([TrigPointJSON].self): \(error)")
        }
    }
    
    // This is from WWDC talk: https://developer.apple.com/documentation/coredata/loading_and_displaying_a_large_data_feed
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        return taskContext
    }
    
    private func newBatchInsertRequest(with pointsList: [TrigPointJSON]) -> NSBatchInsertRequest {
        var index = 0
        let total = pointsList.count

        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: TrigPoint.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: pointsList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    private func importTrigPoints(from pointsList: [TrigPointJSON]) async throws {
        guard !pointsList.isEmpty else { return }

        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importTrigPoints"

        /// - Tag: performAndWait
        try await taskContext.perform {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequest = self.newBatchInsertRequest(with: pointsList)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            throw TrigPointError.batchInsertError
        }
    }
}

extension TrigPoint {
    
    enum Condition : String, Codable, CaseIterable, Identifiable {
        case good = "Good"
        case remains = "Remains"
        case unknown = "Unknown"
        case toppled = "Toppled"
        case visible = "Unreachable but visible"
        case slightlyDamaged = "Slightly damaged"
        case damaged = "Damaged"
        case destroyed = "Destroyed"
        case converted = "Converted"
        case inaccessible = "Inaccessible"
        case moved = "Moved"
        case notLogged = "Not Logged"
        case possiblyMissing = "Possibly missing"
        case uncategorised = ""
        
        var id: String { rawValue }
    }
    
    var cond: Condition {
        Condition(rawValue: condition ?? "")!
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
