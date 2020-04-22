//
//  CurrentWeather.swift
//  Weather
//
//  Created by user on 4/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

struct CurrentWeather {
    var cityName:String
    var description:String
    var temperature: String
    var dayOfWeek: String
    
    init(cityName:String, description: String, temperature:String, dayOfWeek:String) {
        self.cityName = cityName
        self.description = description
        self.temperature = temperature
        self.dayOfWeek = dayOfWeek
    }
}
