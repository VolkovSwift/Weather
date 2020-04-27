//
//  SearchVC.swift
//  Weather
//
//  Created by user on 4/21/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import MapKit

final class SearchVC: UIViewController {
    
    //MARK: - Properties
    
    private let searchTableCellIdentifier = "searchResultCell"
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    var locationsData = LocationsData()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTable: UITableView!
    
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureSearchCompleter()
        configureSearchResultTable()
    }
    
    
    //MARK: - Main Methods
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    
    private func configureSearchCompleter() {
        searchCompleter.delegate  = self
        searchCompleter.resultTypes = .address
    }
    
    
    private func configureSearchResultTable() {
        searchResultTable.dataSource = self
        searchResultTable.delegate = self
    }
}


//MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }
        searchCompleter.queryFragment = searchText
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
}


//MARK: - MKLocalSearchCompleterDelegate

extension SearchVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
}


//MARK: - UITableViewDataSource & UITableViewDelegate

extension SearchVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTable.dequeueReusableCell(withIdentifier: searchTableCellIdentifier, for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [unowned self] (response, error) in
            guard error == nil else {
                self.presentAlert(message: ErrorMessage.localSearchCompleterFail.rawValue)
                return
            }
            
            guard let placeMark = response?.mapItems[0].placemark else {
                return
            }
            
            let newLocation:Location = Location(cityName: placeMark.locality ?? selectedResult.title, latitude: placeMark.coordinate.latitude, longitude: placeMark.coordinate.longitude)
            
            if !self.locationsData.locations.contains(where: {$0.cityName == newLocation.cityName}) {
                self.locationsData.locations.append(newLocation)
            }
            
            PersistenceManager.save(locationsData: self.locationsData)
            self.dismiss(animated: true)
        }
    }
}
