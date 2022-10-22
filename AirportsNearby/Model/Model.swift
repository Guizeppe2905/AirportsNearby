//
//  Model.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import Foundation

struct AirportsModel: Decodable {

        var city: String
        var url: String
        var name: String
        var code: String
        var country: String
        var icao: String
        var phone: String
        var lat: String
        var lon: String
        var type: String
    
}
