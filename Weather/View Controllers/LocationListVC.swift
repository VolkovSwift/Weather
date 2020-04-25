//
//  LocationListVC.swift
//  Weather
//
//  Created by user on 4/21/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

class LocationListVC: UITableViewController {
    
    
    //MARK: - Properties
    static let identifier = "LocationListViewController"
    var locationNames = LocationNames()
    var delegate:LocationListViewDelegate?
    
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(locationNames.names.count)
        tableView.reloadData()
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchVC" {
            let vc = segue.destination as! SearchVC
            vc.locationNames = locationNames
        }
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames.names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath) as! LocationListTableViewCell
        let currentName = locationNames.names[indexPath.row]
        cell.locationNameLabel.text = currentName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locationNames.names.remove(at: indexPath.row)
            PersistenceManager.save(locationNames: self.locationNames)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedName = locationNames.names[indexPath.row]
        delegate?.userDidSelectLocation(locationName: selectedName)
        dismiss(animated: true)
        
    }
    
}
