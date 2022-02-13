//
//  TrigJSON.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import Foundation

struct TrigPointJSON: Codable {
    
    enum CodingKeys : String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
        case height = "height_m"
        case id = "tp_num"
        case name = "tp_name"
        case condition = "condition"
        case country = "country"
        case link = "tpuk_link"
    }
    
    var name: String
    var id: String
    var latitude: Double
    var longitude: Double
    var height: Double
    var condition: String
    var country: String
    var link: String
    
    var dictionaryValue: [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
            "height": height,
            "condition": condition,
            "country": country,
            "link": link,
            "identifier": id,
            "name": name
        ]
    }
}
