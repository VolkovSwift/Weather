//
//  WeatherBuilder.swift
//  Weather
//
//  Created by user on 4/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit


class WeatherBuilder {
    
    static let shared = WeatherBuilder()
    
    func getCurrentWeather(for data: WeatherData) -> CurrentWeather {
        let weather = data.list[0].weather[0]
        let firstListItem = data.list[0]
        let dateConverter = DateConverter(timezone: data.city.timezone)
        let convertedDate = dateConverter.convertDateFromUTC(string: firstListItem.dtTxt)
        return CurrentWeather(cityName: data.city.name, description: weather.description, temperature: String(Int(firstListItem.main.temp)), dayOfWeek: convertedDate)
    }
    
    
    func getHourlyWeatherItem(for data: WeatherData) -> [HourlyWeatherItem]{
        let maxItemCount = 25
        var hourlyWeatherItems: [HourlyWeatherItem] = []
        let dateConverter = DateConverter(timezone: data.city.timezone)
        let maxCount = data.list.count > maxItemCount ? maxItemCount : data.list.count
        let weatherList = data.list[0...maxCount]
        for list in weatherList {
            let convertedDate = dateConverter.convertDateFromUTC(string: list.dtTxt)
            let hourDate = convertedDate.getHour()
            let icon = UIImage(named: list.weather[0].icon)
            let temperature = String(Int(list.main.temp))
            let hourlyWeatherItem = HourlyWeatherItem(hour: hourDate, icon: icon, temperature: temperature)
            hourlyWeatherItems.append(hourlyWeatherItem)
        }
        return hourlyWeatherItems
    }
    
    
//    func getDailyWeatherItem(for data: WeatherData) -> [DailyWeatherItem] {
//        var dailyWeatherItems: [DailyWeatherItem] = []
//        let dateConverter = DateConverter(timezone: data.city.timezone)
//        
//        
//        return dailyWeatherItems
//    }
    
    
    func getDetailsWeather(for data: WeatherData) -> DetailWeather {
        let firstItem = data.list[0].main
        return DetailWeather(humidity: firstItem.humidity, regularPressure: firstItem.pressure, seaLevelPressure: firstItem.seaLevel, groundLevelPressure: firstItem.grndLevel, wind: data.list[0].wind, clouds: data.list[0].clouds)
    }
}
