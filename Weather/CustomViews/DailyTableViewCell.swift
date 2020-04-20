//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    static let identifier = "DailyTableViewCell"
    static let height:CGFloat = 44
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maxMinTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .white
        selectionStyle = .none
        backgroundColor = .clear
        dayOfWeekLabel.textColor = .white
        maxMinTemperature.textColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func set(for item: DailyWeatherItem) {
        dayOfWeekLabel.text = item.day.getDayOfWeek()
        weatherIconImageView.image = UIImage(named: item.iconName)
        maxMinTemperature.text = "\(item.temperatureText)°"
        
    }
}
