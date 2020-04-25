//
//  ErrorMessage.swift
//  Weather
//
//  Created by user on 4/16/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

enum ErrorMessage:String, Error {
    case invalidURL = "Bad URL. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToRetrieve = "Sorry, I can't retrieve location names. Please try again"
}
