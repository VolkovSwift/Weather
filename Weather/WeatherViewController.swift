//
//  WeatherViewController.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var weatherData:WeatherData?
    var currentWeather: CurrentWeather!
    var hourlyWeatherItems: [HourlyWeatherItem] = []
    var detailWeather: DetailWeather?
    var dailyWeatherItems:[DailyWeatherItem] = []
    
    
    //    init(weatherData:WeatherData, currentWeather:CurrentWeather) {
    //        self.weatherData = weatherData
    //        self.currentWeather = currentWeather
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    public required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        self.weatherData = nil
    //        self.currentWeather = nil
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.text = "-"
        conditionLabel.text = "-"
        temperatureLabel.text = "-"
        dayOfWeekLabel.text = "-"
        view.backgroundColor = .systemBlue
        
        registerDailyTableViewCells()
        self.hourlyCollectionView.dataSource = self
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        getWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getWeatherData() {
        NetworkManager.shared.getWeather() { [unowned self] result in
            
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
                self.currentWeather = WeatherBuilder.shared.getCurrentWeather(for: weatherData)
                self.hourlyWeatherItems = WeatherBuilder.shared.getHourlyWeatherItem(for: weatherData)
                self.detailWeather = WeatherBuilder.shared.getDetailsWeather(for: weatherData)
                self.dailyWeatherItems = WeatherBuilder.shared.getDailyWeatherItems(for: weatherData)
                //                print(self.detailWeather?.titleValuPairs)
                print(self.dailyWeatherItems)
                
                DispatchQueue.main.async {
                    self.hourlyCollectionView.reloadData()
                    self.dailyTableView.reloadData()
                    self.configureUI()
                }
                
            case .failure(let error):
                print(error.rawValue)
            }
            
            
        }
    }
    
    func configureUI() {
        cityLabel.text = currentWeather.cityName
        conditionLabel.text = currentWeather.description
        temperatureLabel.text = currentWeather.temperature + "°С"
        dayOfWeekLabel.text = currentWeather.dayOfWeek.getDayOfWeek()
        
    }
    
    private func registerDailyTableViewCells() {
        let dailyTableViewCellNib = UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
        dailyTableView.register(dailyTableViewCellNib, forCellReuseIdentifier: DailyTableViewCell.identifier)
        let detailsTableViewCell = UINib(nibName: DetailsTableViewCell.identifier, bundle: nil)
        dailyTableView.register(detailsTableViewCell, forCellReuseIdentifier: DetailsTableViewCell.identifier)
    }
    
}



extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherItems.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else {
            return HourlyCollectionViewCell()
        }
        
        let item  = hourlyWeatherItems[indexPath.row]
        cell.set(for: item)
        return cell
    }
    
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DailyTableViewSection.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DailyTableViewSection(sectionIndex: section) else {
            return 0
        }
        switch section {
        case .daily:
            return dailyWeatherItems.count
        case .detail:
            return detailWeather?.totalRow ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DailyTableViewSection(sectionIndex: indexPath.section) else {
            return DailyTableViewCell()
        }
        switch section {
        case .daily:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return DailyTableViewCell() }
            
            let weatherItem = dailyWeatherItems[indexPath.row]
            cell.set(for: weatherItem)
            return cell
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as? DetailsTableViewCell else {return DetailsTableViewCell() }
            
            // OPTIONAL TO SOLVE PROBLEM:
            let weatherPair = detailWeather!.getDetailWeather(at: indexPath.row)
            
            cell.setWeatherData(using: weatherPair)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = DailyTableViewSection(sectionIndex: indexPath.section) else {
            return DailyTableViewSection.defaultCellHeight
        }
        return section.cellHeight
    }
    
    
}
