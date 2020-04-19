//
//  DetailsWeather.swift
//  Weather
//
//  Created by user on 4/19/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

class DetailWeather {
    typealias DetailWeatherAtRow = (TitleValuePair, TitleValuePair)
    typealias TitleValuePair = (title: String, value: String)
    
    private struct Constants {
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let seaLevelPressure = "sea level pressure"
        static let groundLevelPressure = "ground level pressure"
        static let wind = "wind"
        static let clouds = "clouds"
    }
    
    var titleValuPairs = [TitleValuePair]()
    var totalRow: Int {
        return self.titleValuPairs.count / 2
    }
    
    init(humidity: Int, regularPressure: Double, seaLevelPressure: Double, groundLevelPressure: Double, wind: Wind, clouds: Clouds) {
        titleValuPairs.append((Constants.humidity, "\(humidity)"))
        titleValuPairs.append((Constants.pressure, "\(regularPressure)"))
        titleValuPairs.append((Constants.seaLevelPressure, "\(seaLevelPressure)"))
        titleValuPairs.append((Constants.groundLevelPressure, "\(groundLevelPressure)"))
        titleValuPairs.append((Constants.wind, "\(wind)"))
        titleValuPairs.append((Constants.clouds, "\(clouds)"))
    }
    
    func getDetailWeather(at rowIndex: Int) -> DetailWeatherAtRow {
        let index = rowIndex * 2
        let leftItem = titleValuPairs[index]
        let rightItem = titleValuPairs[index + 1]
        return (leftItem, rightItem)
    }
}
