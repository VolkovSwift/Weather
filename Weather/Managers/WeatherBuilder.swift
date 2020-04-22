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
        let dayOfWeek = convertedDate.getDayOfWeek()
        return CurrentWeather(cityName: data.city.name, description: weather.description, temperature: String(Int(firstListItem.main.temp)), dayOfWeek: dayOfWeek)
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
    
    
    func getDailyWeatherItems(for data: WeatherData) -> [DailyWeatherItem] {
        let dateConverter = DateConverter(timezone: data.city.timezone)
        var minTemperature = [String: Double]()
        var maxTemperature = [String: Double]()
        var firstDate = [String: Date]()
        var firstIcon = [String: String]()
        for item in data.list {
            let dayOfWeek = dateConverter.convertDateFromUTC(string: item.dtTxt).getDayOfWeek()
            minTemperature.merge([dayOfWeek: item.main.tempMin]) { return $0 > $1 ? $1 : $0 }
            maxTemperature.merge([dayOfWeek: item.main.tempMax]) { return $0 > $1 ? $0 : $1 }
            firstDate.merge([dayOfWeek: dateConverter.convertDateFromUTC(string: item.dtTxt)]) { (first, second) in first }
            firstIcon.merge([dayOfWeek: item.weather[0].icon]) { (first, second) in first }
        }
        var dailyWeatherItems = [DailyWeatherItem]()
        for key in minTemperature.keys {
            let dailyWeatherItem = DailyWeatherItem(dayOfWeek: firstDate[key]!, iconName: firstIcon[key]!, maxTemperature: Int(maxTemperature[key]!), minTemperature: Int(minTemperature[key]!))
            dailyWeatherItems.append(dailyWeatherItem)
        }

        dailyWeatherItems.sort(by: {(first, second) in
            first.dayOfWeek < second.dayOfWeek
        })
        dailyWeatherItems.remove(at: 0)
        return dailyWeatherItems
    }
    
    
    
    func getDetailsWeather(for data: WeatherData) -> DetailsWeather {
        let firstItem = data.list[0].main
        return DetailsWeather(humidity: firstItem.humidity, regularPressure: firstItem.pressure, seaLevelPressure: firstItem.seaLevel, groundLevelPressure: firstItem.grndLevel, wind: data.list[0].wind, clouds: data.list[0].clouds)
    }
}
