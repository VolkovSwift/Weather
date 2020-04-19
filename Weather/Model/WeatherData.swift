//
//  WeatherData.swift
//  Weather
//
//  Created by user on 4/16/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation


//MARK: - Weather

struct WeatherData: Codable {
    let cnt:Int
    let list: [List]
    let city: City
}

//MARK: - Weather

struct List:Codable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
    let dtTxt: String
    let rain: Rain?
    let snow: Snow?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

//MARK: - City

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let timezone: Int
}

//MARK: - MainClass

struct MainClass: Codable {
    let temp, tempMin, tempMax, pressure: Double
    let seaLevel, grndLevel: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
    }
}

//MARK: - WeatherElement

struct WeatherElement: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

//MARK: - Clouds

struct Clouds: Codable {
    let all: Int

    var text:String {
        return "\(all)"
    }
}

//MARK: - Wind

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Coord: Codable {
    let lat, lon:Double
}
