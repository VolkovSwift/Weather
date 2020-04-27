//
//  DateConverter.swift
//  Weather
//
//  Created by user on 4/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

final class DateConverter {
    private let timezone: Double
    
    init(timezone: Int) {
        self.timezone = Double(timezone)
    }
    
    func convertDateFromUTC(string: String) -> Date {
        let utcDate = convertDate(from: string)
        return utcDate.addingTimeInterval(self.timezone)
    }
    
    private func convertDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
}
