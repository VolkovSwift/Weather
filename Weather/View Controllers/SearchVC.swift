//
//  SearchVC.swift
//  Weather
//
//  Created by user on 4/21/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import MapKit

class SearchVC: UIViewController {
    
    static let identifier = "SearchViewController"
    private let searchTableCellIdentifier = "searchResultCell"
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpSearchCompleter()
        setUpSearchResultTable()
    }
    
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    private func setUpSearchCompleter() {
        searchCompleter.delegate  = self
        searchCompleter.filterType = .locationsOnly
    }
    
    private func setUpSearchResultTable() {
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


//MARK: - UITableViewDataSource & UITableViewDelegate

extension SearchVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("TODO")
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
        search.start { (response, error) in
            guard error == nil else {
                print("Local Search Request Error : No corresoponding location data for user selection")
                return
            }
            
            guard let placeMark = response?.mapItems[0].placemark else {
                return
            }
            let coordinate = placeMark.coordinate
            let locationName = "\(placeMark.locality ?? selectedResult.title)"
            print(locationName)
            //TODO
            self.dismiss(animated: true)
        }
    }
}
