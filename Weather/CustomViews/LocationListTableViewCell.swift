//
//  LocationListTableViewCell.swift
//  Weather
//
//  Created by user on 4/21/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class LocationListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var locationNameLabel: UILabel!

    func set(location: Location) {
        locationNameLabel.text = location.cityName
    }
}
