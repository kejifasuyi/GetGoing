//
//  APIParser.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-23.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation
import CoreLocation

class APIParser {
    
    class func parseNearbySearchResults(jsonObj: [String: Any]) -> [PlaceDetails] {
        var places :[PlaceDetails] = []
        
        //Parsing general root object
        if let results = jsonObj["results"] as? [[String: Any]] {
            results.forEach { (result) in
                if let place = PlaceDetails(json: result) {
                places.append(place)
            
        }
    }
}
        return places
    }
    
    
    class func parseNewDetails(jsonObj: [String: Any]) -> PlaceDetails {
        var places: PlaceDetails = PlaceDetails(id: "", name: "", vicinity: "", formattedAddress: "", rating: 0.0, icon: "", place_id: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), website: "", formatted_phone_number: "")

        //Parsing general root object
        if let results = jsonObj["result"] as? [String: Any]{
         
                if let place = PlaceDetails(json: results) {
                    places = place
                }
            }
        
        return places
    }
    
}
