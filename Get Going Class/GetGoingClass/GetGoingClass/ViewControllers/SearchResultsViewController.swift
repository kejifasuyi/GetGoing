//
//  SearchResultsViewController.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-23.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedOrder: UISegmentedControl!
    
    var places: [PlaceDetails]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchResultTableViewCell")
        
        places.sort() { $0.name! < $1.name!} // default sort places by name
    }
    
    
    
    
    //Newly Added
    @IBAction func segementedRanker(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            sortListByRating()
        }
        if sender.selectedSegmentIndex == 0 {
            sortList()
        }
    }
    
    func sortList() {
        places.sort() { $0.name! < $1.name!} // sort places by name
            tableView.reloadData(); // notify the table view the data has changed
           }
    
    func sortListByRating() {
        places.sort() { $0.rating! > $1.rating!} // sort places by rating
        tableView.reloadData(); // notify the table view the data has changed
    }
    
    func presentDetails(_ results: PlaceDetails?, _ cellRowNo: Int) {
        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.places = results
        detailsViewController.indexNo = cellRowNo
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as?
            SearchResultTableViewCell else {
                return UITableViewCell()
        }
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.vicinityLabel.text = place.address
        
        if let placeRating = place.rating {
            cell.rating.rating = Int(placeRating.rounded(.down))
        }
        
        guard let iconStr = place.icon,
        let iconURL = URL(string: iconStr),
        let imageData = try? Data(contentsOf: iconURL) else {
            cell.iconImageView.image = UIImage.init(named: "StarEmpty")
            return cell
        }
        cell.iconImageView.image = UIImage(data: imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Cell")
        let place = places[indexPath.row]
        print("Indexpathrowno: \(indexPath.row)")
       self.presentDetails(place, indexPath.row)
//        GooglePlacesAPI.requestDetails(place.place_id ?? "") { (status, json) in
//            print(json ?? "")
//
//            guard let jsonObj = json else { return }
//            let results = APIParser.parseNewDetails(jsonObj: jsonObj)
//
//            if results.isEmpty {
//                //TODO: Present an alert
//                DispatchQueue.main.async {
//                    print("No results")
//                }
//            }
//            else {
//                self.presentDetails(results, indexPath.row)
//            }
//        }
    }
}
