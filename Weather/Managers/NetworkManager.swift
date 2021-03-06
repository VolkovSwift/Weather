//
//  NetworkManager.swift
//  Weather
//
//  Created by user on 4/16/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit


final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getWeather(location: Location, handler: @escaping(Result<WeatherData, ErrorMessage>) -> Void) {
        
        let baseURL = "http://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=e570eb3a7803219ec896eb79d15dad73&units=metric"
        
        guard let url = URL(string: baseURL) else {
            handler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data,response, error) in
            
            
            if let _ = error {
                handler(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                handler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                handler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                handler(.success(weatherData))
            } catch {
                handler(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
