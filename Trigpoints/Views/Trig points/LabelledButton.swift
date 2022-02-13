//
//  LabelledButton.swift
//  Trigtastic
//
//  Created by Michael Dales on 12/02/2022.
//

import SwiftUI

struct LabelledButton: View {
    var label: String
    var imageName: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: imageName)
                    .imageScale(.large)
                Text(label)
                    .font(.caption)
            }
            Spacer()
        }
        .padding()
        .cornerRadius(10)
    }
}

struct LabelledButton_Previews: PreviewProvider {
    static var previews: some View {
        LabelledButton(label: "Browser", imageName: "safari.fill")
    }
}
