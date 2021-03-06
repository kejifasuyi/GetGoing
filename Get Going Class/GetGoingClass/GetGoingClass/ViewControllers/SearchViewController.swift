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
    
    @IBOutlet weak var presentFilterButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Outlets
    var searchParameter: String?
    var currentLocation: CLLocationCoordinate2D?
    
    //Newly Added
    var radiusVal = Double(Constants.defaultRadius)
    var rankByVal = Constants.defaultRankBy
    var openNowVal = Constants.defaultOpenNow
    
    
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
        guard let places = loadPlacesFromLocalStorage() else {
            presentErrorAlert(message: "No results were previously stored")
            return
        }
        presentSearchResults(places)
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
        
        print("After changing the settings: \(radiusVal) \(rankByVal)")
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            GooglePlacesAPI.requestPlaces(query, opennow: openNowVal) { (status, json) in
            print(json ?? "")
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            
            guard let jsonObj = json else { return }
            let results = APIParser.parseNearbySearchResults(jsonObj: jsonObj)
            
            self.savePlacesToLocalStorage(places: results)
                
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
            
            GooglePlacesAPI.requestPlacesNearby(for: location, radius: Double(radiusVal), query, opennow: openNowVal, rankby: rankByVal) { (status, json) in
                print(json ?? "")
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                
                guard let jsonObj = json else { return }
                let results = APIParser.parseNearbySearchResults(jsonObj: jsonObj)
                
                self.savePlacesToLocalStorage(places: results)
                
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
    
    func savePlacesToLocalStorage(places: [PlaceDetails]) {
        // save data to the local storage
        NSKeyedArchiver.archiveRootObject(places, toFile: Constants.ArchiveURL.path)
    }
    
    func loadPlacesFromLocalStorage() -> [PlaceDetails]? {
        // pull data from the local storage
        return NSKeyedUnarchiver.unarchiveObject(withFile: Constants.ArchiveURL.path) as? [PlaceDetails]
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
        radiusVal = radius
        rankByVal = rankBy
        openNowVal = openNow
        
        if radiusVal != Double(Constants.defaultRadius)  || rankByVal != Constants.defaultRankBy || openNowVal != Constants.defaultOpenNow {
            
            presentFilterButton.setImage(UIImage(named: "filters"), for: .normal)
        }
        else{
            presentFilterButton.setImage(UIImage(named: "filtersDefault"), for: .normal)
        }
    }
}
