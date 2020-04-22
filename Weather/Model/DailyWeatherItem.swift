//
//  DailyWeatherItem.swift
//  Weather
//
//  Created by user on 4/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

struct DailyWeatherItem {
    var dayOfWeek: Date
    var iconName: String
    var maxTemperature: Int
    var minTemperature: Int
    
    var temperatureText: String {
        return "\(maxTemperature)°  \(minTemperature)°"}
    
}
