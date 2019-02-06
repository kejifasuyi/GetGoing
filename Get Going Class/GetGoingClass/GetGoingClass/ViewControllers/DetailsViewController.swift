//
//  DetailsViewController.swift
//  GetGoingClass
//
//  Created by Admin on 2019-02-05.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var places: PlaceDetails!
    var indexNo: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        phoneLabel.isHidden = true
        websiteLabel.isHidden = true
        showActivityIndicator()
       
        
        GooglePlacesAPI.requestDetails(places.place_id ?? "") { (status, json) in
            print(json ?? "")

            guard let jsonObj = json else { return }
            let results = APIParser.parseNewDetails(jsonObj: jsonObj)

            if results.isEqual(nil) {
                //TODO: Present an alert
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    print("No results")
                }
            }
            else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.phoneLabel.text = results.formatted_phone_number!
                    self.websiteLabel.text = results.website!
                    self.phoneLabel.isHidden = false
                    self.websiteLabel.isHidden = false
                }
                
            }
        }

    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    

}

