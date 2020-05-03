//
//  Date + ext.swift
//  Weather
//
//  Created by user on 4/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

extension Date {
    func getDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    
    func getHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}
