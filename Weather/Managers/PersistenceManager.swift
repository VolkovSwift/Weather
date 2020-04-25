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
        static let locationNames = "locationNames"
    }
    
    static func retrieveLocationNames(completed: @escaping (Result<LocationNames, ErrorMessage>) -> Void) {
        guard let locationNamesData = defaults.object(forKey: Keys.locationNames) as? Data else {
            completed(.failure(.unableToRetrieve))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let locationNames = try decoder.decode(LocationNames.self, from: locationNamesData)
            completed(.success(locationNames))
        } catch {
            completed(.failure(.unableToRetrieve))
        }
    }
    
    static func save(locationNames: LocationNames) {
        do {
            let encoder = JSONEncoder()
            let encodedNames = try encoder.encode(locationNames)
            defaults.set(encodedNames, forKey: Keys.locationNames)
        } catch {
            print(error)
        }
    }
}
