//
//  PersistenceManager.swift
//  Weather
//
//  Created by user on 4/23/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let locationsData = "locationsData"
    }
    
    
    static func retrieveLocations(completed: @escaping (Result<LocationsData, ErrorMessage>) -> Void) {
        guard let locationsData = defaults.object(forKey: Keys.locationsData) as? Data else {
            completed(.success(LocationsData()))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let locationsData = try decoder.decode(LocationsData.self, from: locationsData)
            completed(.success(locationsData))
        } catch {
            completed(.failure(.unableToRetrieve))
        }
    }
    
    
    static func save(locationsData: LocationsData) {
        do {
            let encoder = JSONEncoder()
            let encodedLocationsData = try encoder.encode(locationsData)
            defaults.set(encodedLocationsData, forKey: Keys.locationsData)
        } catch {
            print(error)
        }
    }
}
