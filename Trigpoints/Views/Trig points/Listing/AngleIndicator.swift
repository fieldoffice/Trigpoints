//
//  AngleIndicator.swift
//  Trigpoints
//
//  Created by Michael Dales on 14/02/2022.
//

import SwiftUI

struct AngleIndicator: View {
    var angle: Double
    
    var description: String {
        let adjusted = (Int(angle) + 360) % 360
        
        switch adjusted {
        case 45..<135:
            return "Due east"
        case 135..<225:
            return "Due south"
        case 225..<315:
            return "Due west"
        default:
            return "Due north"
        }
    }
    
    var body: some View {
        Image(systemName: "arrow.up")
            .rotationEffect(Angle(degrees: angle))
            .accessibilityLabel(description)
    }
}

struct AngleIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AngleIndicator(angle: 45.0)
    }
}
