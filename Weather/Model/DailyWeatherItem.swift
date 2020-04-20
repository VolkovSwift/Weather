//
//  DailyWeatherItem.swift
//  Weather
//
//  Created by user on 4/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

struct DailyWeatherItem {
    
    var day: Date
    var iconName: String
    var maxTemperature: Double
    var minTemperature: Double
    
    
    var temperatureText: String {
        return "\(maxTemperature)  \(minTemperature)"
    }
    
    //    init(iconName: String, tempMax: Double, tempMin: Double, dateText: String) {
    //        self.iconName = iconName
    //        self.tempMax = tempMax
    //        self.tempMin = tempMin
    //        self .dateText = dateText
    //    }
}
