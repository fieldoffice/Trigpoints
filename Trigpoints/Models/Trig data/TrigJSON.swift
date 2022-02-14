//
//  TrigJSON.swift
//  Trigpoints
//
//  Created by Michael Dales on 13/02/2022.
//

import Foundation

//{
//    "aonb": "",
//    "birkett": false,
//    "condition": "Good",
//    "corbett": false,
//    "country": "Scotland",
//    "country_top": false,
//    "current_use": "Passive station",
//    "fb_number": "S4928",
//    "full_name": "TP0001 - Fetlar",
//    "gridref_10": "HU6222993521",
//    "gridref_2": "HU",
//    "gridref_4": "HU6293",
//    "gridref_6": "HU622935",
//    "height_ft": 521.0,
//    "height_m": 158.8,
//    "hewitt": false,
//    "historic_use": "Primary",
//    "lat": 60.62023137,
//    "long": -0.864819279,
//    "marilyn": true,
//    "munro": false,
//    "nat_park": "",
//    "nuttall": false,
//    "os_map_link": "http://www.bing.com/maps/default.aspx?lvl=17&style=s&cp=60.62023137~-0.864819279",
//    "sheet": "1",
//    "tp_name": "Fetlar",
//    "tp_num": "TP0001",
//    "tpuk_link": "http://www.trigpointinguk.com/trigs/trig-details.php?t=1",
//    "trail_100": false,
//    "type": "Pillar",
//    "wain": false,
//    "wain_outlying": false
//},


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
        case pointType = "type"
        case currentUse = "current_use"
        case historicUse = "historic_use"
    }
    
    var name: String
    var id: String
    var latitude: Double
    var longitude: Double
    var height: Double
    var condition: String
    var country: String
    var link: String
    var pointType: String
    var currentUse: String
    var historicUse: String
    
    var dictionaryValue: [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
            "height": height,
            "condition": condition,
            "country": country,
            "link": link,
            "identifier": id,
            "name": name,
            "type": pointType,
            "currentUse": currentUse,
            "historicUse": historicUse,
        ]
    }
}
