//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    static let identifier = "HourlyCollectionViewCell"
    
    func set(for item: HourlyWeatherItem) {
        hourLabel.text = item.hour
        weatherIconImageView.image = item.icon
        temperatureLabel.text = "\(item.temperature)°"
        
    }
}
