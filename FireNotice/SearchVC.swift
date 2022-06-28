//
//  searchVC.swift
//  fireTracker
//
//  Created by JOJO
//  Copyright © 2020 Jayu. All rights reserved.
//
import UIKit
import MapKit
import Foundation
class SearchViewController: UIViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var locationTableView = LoactionTableViewController()
    var searchResults = [MKLocalSearchCompletion]()
    var name: String = ""
    var nameArray: [String] = UserDefaults.standard.object(forKey: "nameKey101") as? [String] ?? []
    var locationArrayLong: [String] = UserDefaults.standard.object(forKey: "locationKey121") as? [String] ?? []
    var locationArrayLad: [String] = UserDefaults.standard.object(forKey: "locationKey136") as? [String] ?? []
    
    
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchCompleter.delegate = self
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.textLabel?.font = UIFont(name: "TrebuchetMS", size: 15)
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let alert = UIAlertController(title: "Enter Name for Location", message: "Name", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
            }

            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.name = (textField?.text)!
                self.nameArray.append(self.name)
                    self.locationArrayLad.append(String((coordinate?.latitude)!))
                    self.locationArrayLong.append(String((coordinate?.longitude)!))
            
                    UserDefaults.standard.set(self.nameArray, forKey: "nameKey101")
                    UserDefaults.standard.set(self.locationArrayLad, forKey: "locationKey136")
                    UserDefaults.standard.set(self.locationArrayLong, forKey: "locationKey121")
                
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                        self.locationTableView.tableView.reloadData()
                        }
                    }

                print(self.locationArrayLad)
                print(self.locationArrayLong)
                self.locationTableView.tableView.reloadData()
            }))

            self.present(alert, animated: true, completion: nil)
            print(String(describing: coordinate!))
        }
    }
}
