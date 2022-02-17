//
//  ListFilters.swift
//  Trigpoints
//
//  Created by Michael Dales on 17/02/2022.
//

import SwiftUI

struct ListFilters: View {
    @AppStorage("showGoodOnly") var showGoodOnly: Bool = false
        
    var body: some View {
        List {
            Section("General") {
                Toggle(isOn: $showGoodOnly) {
                    Text("Only show reported good condition points")
                }
            }
        }
    }
}

struct ListFilters_Previews: PreviewProvider {
    static var previews: some View {
        ListFilters()
    }
}
