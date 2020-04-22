//
//  DetailsTableViewCell.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
    
    static let identifier = "DetailsTableViewCell"
    static let height: CGFloat = 90
    
    @IBOutlet private weak var leftTitleLabel: UILabel!
    @IBOutlet private weak var leftValueLabel: UILabel!
    @IBOutlet private weak var rightTitleLabel: UILabel!
    @IBOutlet private weak var rightValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        leftTitleLabel.adjustsFontSizeToFitWidth = true
        rightTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setWeatherData(using weatherAtRow: DetailsWeather.DetailWeatherAtRow) {
        let (left, right) = weatherAtRow
        self.leftTitleLabel.text = left.title
        self.leftValueLabel.text = left.value
        self.rightTitleLabel.text = right.title
        self.rightValueLabel.text = right.value
    }
    
}
