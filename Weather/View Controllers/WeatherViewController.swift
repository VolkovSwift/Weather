//
//  WeatherViewController.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    //MARK: - Properties
    
    var weatherData:WeatherData?
    var currentWeather:CurrentWeather!
    var hourlyWeatherItems: [HourlyWeatherItem] = []
    var detailsWeather: DetailsWeather!
    var dailyWeatherItems:[DailyWeatherItem] = []
    var locationNames = LocationNames()
    var locationManager = CLLocationManager()
    var coordinatesForCurrentCity: CLLocationCoordinate2D?
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        clearWeather()
        getSavedLocations()
        setUpLocationManager()
        registerDailyTableViewCells()
    }
    
    
    //MARK: - Main Methods
    
    private func setUpDelegates() {
        hourlyCollectionView.dataSource = self
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        locationManager.delegate = self
    }
    
    private func clearWeather() {
        cityLabel.text = "-"
        conditionLabel.text = "-"
        temperatureLabel.text = "-"
        dayOfWeekLabel.text = "-"
    }
    
    private func setUpLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getSavedLocations() {
        PersistenceManager.retrieveLocationNames { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let locationNames):
                self.locationNames = locationNames
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getWeatherData(cityName: String) {
        NetworkManager.shared.getWeather(city: cityName) { [unowned self] result in
            
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
                self.currentWeather = WeatherBuilder.shared.getCurrentWeather(for: weatherData)
                self.hourlyWeatherItems = WeatherBuilder.shared.getHourlyWeatherItem(for: weatherData)
                self.detailsWeather = WeatherBuilder.shared.getDetailsWeather(for: weatherData)
                self.dailyWeatherItems = WeatherBuilder.shared.getDailyWeatherItems(for: weatherData)
                //                print(self.hourlyWeatherItems)
                
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
    
    private func configureUI() {
        cityLabel.text = currentWeather.cityName
        conditionLabel.text = currentWeather.description
        temperatureLabel.text = currentWeather.temperature + "°С"
        dayOfWeekLabel.text = currentWeather.dayOfWeek
        
    }
    
    private func registerDailyTableViewCells() {
         let dailyTableViewCellNib = UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
         dailyTableView.register(dailyTableViewCellNib, forCellReuseIdentifier: DailyTableViewCell.identifier)
         let detailsTableViewCell = UINib(nibName: DetailsTableViewCell.identifier, bundle: nil)
         dailyTableView.register(detailsTableViewCell, forCellReuseIdentifier: DetailsTableViewCell.identifier)
     }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationListVC" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? LocationListVC {
                targetController.delegate = self
                targetController.locationNames = locationNames
            }
        }
    }
}


//MARK: - UICollectionViewDataSource

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


//MARK: - UITableViewDataSource & UITableViewDelegate

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
            return detailsWeather?.totalRow ?? 0
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
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            
            let weatherPair = detailsWeather.getDetailWeather(at: indexPath.row)
            
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

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        
        if (currentLocation.horizontalAccuracy > 0) {
            locationManager.stopUpdatingLocation()
            
            CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemark, error) in
                
                if error == nil, let placemark = placemark, !placemark.isEmpty {
                    guard let cityName = placemark[0].locality else {return}
                    self.locationNames.names.append(cityName)
                    self.getWeatherData(cityName: cityName)
                    
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    
}

//MARK: - LocationListViewDelegate

extension WeatherViewController:LocationListViewDelegate {
    func userDidSelectLocation(locationName: String) {
        getWeatherData(cityName: locationName)
    }
}
