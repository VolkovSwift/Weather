//
//  WeatherViewController.swift
//  Weather
//
//  Created by user on 4/15/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

final class WeatherViewController: UIViewController {
    
    //MARK: - Properties
    
    private var weatherData:WeatherData?
    private var currentWeather:CurrentWeather?
    private var hourlyWeatherItems: [HourlyWeatherItem] = []
    private var dailyWeatherItems:[DailyWeatherItem] = []
    private var detailsWeather: DetailsWeather!
    private var locationsData = LocationsData()
    private var locationManager = CLLocationManager()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    @IBOutlet private weak var dailyTableView: UITableView!
    
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        clearWeather()
        configureBackground()
        getSavedLocations()
        configureLocationManager()
        registerDailyTableViewCells()
    }
    
    
    //MARK: - Main Methods
    

    
    private func configureDelegates() {
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
    
    
    private func configureBackground () {
        let backgroundImage  = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    
    private func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    private func getSavedLocations() {
        PersistenceManager.retrieveLocations { [unowned self] result in
            switch result {
            case .success(let locationsData):
                self.locationsData = locationsData
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    
    private func getWeatherData(location: Location) {
        NetworkManager.shared.getWeather(location: location) { [unowned self] result in
            
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
                self.currentWeather = WeatherBuilder.shared.getCurrentWeather(for: weatherData)
                self.hourlyWeatherItems = WeatherBuilder.shared.getHourlyWeatherItem(for: weatherData)
                self.detailsWeather = WeatherBuilder.shared.getDetailsWeather(for: weatherData)
                self.dailyWeatherItems = WeatherBuilder.shared.getDailyWeatherItems(for: weatherData)
                
                DispatchQueue.main.async {
                    self.hourlyCollectionView.reloadData()
                    self.dailyTableView.reloadData()
                    self.configureUI()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(message: error.rawValue)
                }
            }
        }
    }
    
    
    private func configureUI() {
        guard let currentWeather = currentWeather else {return}
        cityLabel.text = currentWeather.cityName
        conditionLabel.text = currentWeather.description
        temperatureLabel.text = currentWeather.temperature
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
                targetController.locationsData = locationsData
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
            let weatherItem = dailyWeatherItems[indexPath.row]
            cell.set(for: weatherItem)
            return cell
            
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as! DetailsTableViewCell
            
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
                    let newLocation = Location(cityName: cityName, latitude: Double(currentLocation.coordinate.latitude), longitude: Double(currentLocation.coordinate.longitude))
                    
                    if !self.locationsData.locations.contains(where: {$0.cityName == newLocation.cityName}) {
                        self.locationsData.locations.append(newLocation)
                    }
                    self.getWeatherData(location: newLocation)
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlert(message: ErrorMessage.locationManagerRequestFail.rawValue)
    }
}


//MARK: - LocationListViewDelegate

extension WeatherViewController:LocationListViewDelegate {
    func userDidSelectLocation(location: Location) {
        getWeatherData(location: location)
    }
}
