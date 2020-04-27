//
//  Location.swift
//  Weather
//
//  Created by user on 4/25/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

final class LocationsData: Codable {
    var locations:[Location] = []
}

struct Location: Codable {
    var cityName: String
    var latitude: Double
    var longitude: Double
}

