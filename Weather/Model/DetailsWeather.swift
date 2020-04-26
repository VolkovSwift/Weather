//
//  DetailsWeather.swift
//  Weather
//
//  Created by user on 4/19/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

struct DetailsWeather {
    typealias DetailWeatherAtRow = (TitleValuePair, TitleValuePair)
    typealias TitleValuePair = (title: String, value: String)
    
    private struct Constants {
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let seaLevelPressure = "sea level pressure"
        static let groundLevelPressure = "ground level pressure"
        static let windSpeed = "wind speed"
        static let clouds = "clouds"
    }
    
    var titleValuPairs = [TitleValuePair]()
    var totalRow: Int {
        return self.titleValuPairs.count / 2
    }
    
    init(humidity: Int, regularPressure: Double, seaLevelPressure: Double, groundLevelPressure: Double, wind: Wind, clouds: Clouds) {
        titleValuPairs.append((Constants.humidity, "\(humidity) %"))
        titleValuPairs.append((Constants.pressure, "\(regularPressure) hPa"))
        titleValuPairs.append((Constants.seaLevelPressure, "\(seaLevelPressure) hPa"))
        titleValuPairs.append((Constants.groundLevelPressure, "\(groundLevelPressure) hPa"))
        titleValuPairs.append((Constants.windSpeed, "\(wind.speed) m/s"))
        titleValuPairs.append((Constants.clouds, "\(clouds.all) %"))
    }
    
    func getDetailWeather(at rowIndex: Int) -> DetailWeatherAtRow {
        let index = rowIndex * 2
        let leftItem = titleValuPairs[index]
        let rightItem = titleValuPairs[index + 1]
        return (leftItem, rightItem)
    }
}
