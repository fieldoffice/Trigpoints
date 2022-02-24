//
//  VisitedPointsList.swift
//  Trigpoints
//
//  Created by Michael Dales on 23/02/2022.
//

import SwiftUI

struct VisitedPointsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var locationModel: LocationModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Visit.timestamp, ascending: false)],
        animation: .default)
    private var visits: FetchedResults<Visit>
    
    var body: some View {
        if visits.count > 0 {
            List {
                ForEach(visits) { visit in
                    if let point = visit.point {
                        NavigationLink {
                            DetailView(currentLocation: locationModel.approximateLocation, trigpoint: point)
                        } label: {
                            PointListItem(point: point, currentLocation: locationModel.approximateLocation)
                        }
                    } else {
                        Text("Bad visit data!")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
            }
            .navigationTitle("Visited")
        } else {
            Spacer()
            Text("You've not visited any points yet!")
            Spacer()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { visits[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct VisitedPointsList_Previews: PreviewProvider {
    static var previews: some View {
        VisitedPointsList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
