//
//  SearchViewController.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-16.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Outlets
    var searchParameter: String?
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        searchTextField.delegate = self
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchButton.isEnabled = false
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        searchButton.isEnabled = true
    }
   
    @IBAction func loadLastSavedResults(_ sender: UIButton) {
        
    }
    
    @IBAction func presentFilter(_ sender: UIButton) {
        performSegue(withIdentifier: "FiltersSegue", sender: self)
//        guard let filtersViewController = UIStoryboard(name: "Filters", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController else {return}
//        present(filtersViewController, animated: true, completion: nil)
    }
    
    @IBAction func segmentedObserver(_ sender: UISegmentedControl) {
        print("Segmented control option was changed to \(sender.selectedSegmentIndex)")
        
        if sender.selectedSegmentIndex == 1 {
            LocationService.shared.startUpdatingLocation()
            LocationService.shared.delegate = self            
        }
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        print("search button was tapped")
        guard let query = searchTextField.text else {
            print("query is nil")
            self.hideActivityIndicator()
            return
        }
        
        searchTextField.resignFirstResponder()
        showActivityIndicator()
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
        GooglePlacesAPI.requestPlaces(query) { (status, json) in
            print(json ?? "")
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            
            guard let jsonObj = json else { return }
            let results = APIParser.parseNearbySearchResults(jsonObj: jsonObj)
            
            if results.isEmpty {
                //TODO: Present an alert
                DispatchQueue.main.async {
                    self.presentErrorAlert(message: "No results")
                }
            }
            else {
                self.presentSearchResults(results)
            }
        }
        case 1:
            guard let location = currentLocation else { return }
            
            GooglePlacesAPI.requestPlacesNearby(for: location, radius: 10000.0, query) { (status, json) in
                print(json ?? "")
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                
                guard let jsonObj = json else { return }
                let results = APIParser.parseNearbySearchResults(jsonObj: jsonObj)
                
                if results.isEmpty {
                    //TODO: Present an alert
                    DispatchQueue.main.async {
                        self.presentErrorAlert(message: "No results")
                    }
                }
                else {
                    self.presentSearchResults(results)
                }
            }
        default:
            break
        }
    }
    
    
    func presentSearchResults(_ results: [PlaceDetails]?) {
        let searchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsViewController.places = results
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        }
    }
    
    func presentErrorAlert(title: String = "Error", message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okButtonAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FiltersViewController
        
        destinationVC.filterDelegate = self
       // print("Did this segue happen?")
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchTextField.resignFirstResponder()
            print("textFieldShouldReturn")
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextField {
            searchParameter = textField.text
            print(textField.text ?? "")
        }
    }
    
    
}

extension SearchViewController: LocationServiceDelegate {
    
    func didUpdateLocation(location: CLLocation) {
        print("latitude \(location.coordinate.latitude) longitude \(location.coordinate.longitude)")
        currentLocation = location.coordinate
        }
}

extension SearchViewController: filterViewDelegate {
    func updateFilterSettings(radius: Double, rankBy: String, openNow: Bool) {
        print("Protocol works \(radius) bla \(rankBy) \(openNow)")
    }
}
