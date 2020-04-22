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
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var locationManager = CLLocationManager()
//    var currentLocation: CLLocation?
    var coordinatesForCurrentCity: CLLocationCoordinate2D?
    
    var weatherData:WeatherData?
    var currentWeather:CurrentWeather!
    var hourlyWeatherItems: [HourlyWeatherItem] = []
    var detailsWeather: DetailsWeather!
    var dailyWeatherItems:[DailyWeatherItem] = []
//    var cityName = ""
    
    
//        init(currentWeather:CurrentWeather) {
//            self.currentWeather = currentWeather
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        public required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            self.currentWeather = nil
//        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyCollectionView.dataSource = self
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        locationManager.delegate = self
        
        clearWeather()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        print(coordinatesForCurrentCity)
        
        view.backgroundColor = .systemBlue
        
        registerDailyTableViewCells()

//        getWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func clearWeather() {
        cityLabel.text = "-"
        conditionLabel.text = "-"
        temperatureLabel.text = "-"
        dayOfWeekLabel.text = "-"
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
    
    func configureUI() {
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
                    self.getWeatherData(cityName: cityName)
                    
                }
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    
//    func enableBasicLocationServices() {
//        locationManager.delegate = self
//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            break
//        case .restricted, .denied:
//            clearWeather()
//            break
//        case .authorizedWhenInUse, .authorizedAlways:
//            //enable location features
//            //getWeather()
//            break
//        }
//    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined, .authorizedAlways:
//            locationManager.requestWhenInUseAuthorization()
//            break
//        case .restricted, .denied:
//            clearWeather()
//            break
//        case .authorizedWhenInUse:
//            //getWeather()
//            break
//        }
//    }
    
//    func getWeather() {
//        if ( CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
//
//            currentLocation = locationManager.location
//            print(currentLocation)
//        } else {
//            clearWeather()
//            return
//        }
//    }
    
}
