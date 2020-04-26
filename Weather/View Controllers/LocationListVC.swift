//
//  LocationListVC.swift
//  Weather
//
//  Created by user on 4/21/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class LocationListVC: UITableViewController {
    
    
    //MARK: - Properties
    
    static let identifier = "LocationListViewController"
    var delegate:LocationListViewDelegate?
    var locationsData = LocationsData()

    
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchVC" {
            let vc = segue.destination as! SearchVC
            vc.locationsData = locationsData
        }
    }
    
    
    //MARK: - Main Methods
    
    private func configureViewController() {
        title = "Locations"
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    // MARK: - Table view data source & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsData.locations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath) as! LocationListTableViewCell
        let currentLocation = locationsData.locations[indexPath.row]
        cell.locationNameLabel.text = currentLocation.cityName
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locationsData.locations.remove(at: indexPath.row)
            PersistenceManager.save(locationsData: locationsData)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentLocation = locationsData.locations[indexPath.row]
        delegate?.userDidSelectLocation(location: currentLocation)
        dismiss(animated: true)
    }
}
