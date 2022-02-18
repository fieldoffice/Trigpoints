//
//  VisitedSheet.swift
//  Trigpoints
//
//  Created by Michael Dales on 17/02/2022.
//

import SwiftUI

struct VisitedSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @State private var notes: String = ""
    
    var trigpoint: TrigPoint
    let dateFormatter: DateFormatter
    
    init(trigpoint: TrigPoint) {
        self.trigpoint = trigpoint
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    var body: some View {
        VStack {
            Text("You visited \(trigpoint.name ?? "")!")
                .font(.title)
                .padding()
            Button {
                let visit = Visit(context: viewContext)
                visit.notes = notes
                visit.timestamp = Date()
                visit.point = trigpoint
                do {
                    try viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("Save")
            }
            HStack {
                Text("When: \(dateFormatter.string(from: Date()))")
                    .padding()
                Spacer()
            }
            HStack {
                Text("Notes:")
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            TextEditor(text: $notes)
        }
    }
}

struct VisitedSheet_Previews: PreviewProvider {
    static var previews: some View {
        VisitedSheet(trigpoint: .preview)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
