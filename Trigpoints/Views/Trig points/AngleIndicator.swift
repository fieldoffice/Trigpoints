//
//  AngleIndicator.swift
//  Trigpoints
//
//  Created by Michael Dales on 14/02/2022.
//

import SwiftUI

struct AngleIndicator: View {
    var angle: Double
    
    var body: some View {
        Image(systemName: "arrow.up")
            .rotationEffect(Angle(degrees: angle))
    }
}

struct AngleIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AngleIndicator(angle: 45.0)
    }
}
