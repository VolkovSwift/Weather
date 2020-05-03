//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class DailyTableViewCell: UITableViewCell {

    static let height:CGFloat = 44
    
    
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var maxMinTemperature: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .white
        selectionStyle = .none
        backgroundColor = .clear
        dayOfWeekLabel.textColor = .white
        maxMinTemperature.textColor = .white
    }
    
    
    func set(for item: DailyWeatherItem) {
        dayOfWeekLabel.text = item.dayOfWeek.getDayOfWeek()
        weatherIconImageView.image = UIImage(named: item.iconName)
        maxMinTemperature.text = "\(item.temperatureText)"
    }
}
