//
//  NearbyPoints.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import SwiftUI
import CoreData

struct TopLevel: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var locationModel: LocationModel
    @State private var loaded: Bool = false
    @State private var selectedTab: Tab = .nearby
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var points: FetchedResults<TrigPoint>
    
    enum Tab: Int {
        case nearby
        case visited
    }
    
    var body: some View {
        VStack(spacing:0) {
            if (loaded) {
                ZStack {
                    if selectedTab == .nearby {
                        NavigationView {
                            VStack(spacing:0) {
                                NearbyPointsList(filter: locationModel.approximateLocation)
                                tabBarView
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    } else if selectedTab == .visited {
                        NavigationView {
                            VStack(spacing:0) {
                                VisitedPointsList()
                                tabBarView
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
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
    }
    
    var tabBarView: some View {
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 20) {
                    tabBarItem(.nearby, title: "Nearby", icon: "location.circle", selectedIcon: "location.circle.fill")
                    tabBarItem(.visited, title: "Visited", icon: "star.circle", selectedIcon: "star.circle.fill")
                }
                .padding(.top, 8)
            }
            .frame(height: 50)
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
        
        func tabBarItem(_ tab: Tab, title: String, icon: String, selectedIcon: String) -> some View {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 3) {
                    VStack {
                        Image(systemName: (selectedTab == tab ? selectedIcon : icon))
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == tab ? .primary : .black)
                    }
                    .frame(width: 55, height: 28)
                    
                    Text(title)
                        .font(.system(size: 11))
                        .foregroundColor(selectedTab == tab ? .primary : .black)
                }
            }
            .frame(width: 65, height: 42)
            .onTapGesture {
                selectedTab = tab
            }
        }
    
}

struct TopLevel_Previews: PreviewProvider {
    static var previews: some View {
        TopLevel()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LocationModel())
            .previewInterfaceOrientation(.portrait)
    }
}
