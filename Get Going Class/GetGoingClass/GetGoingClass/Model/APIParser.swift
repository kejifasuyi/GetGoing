//
//  APIParser.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-23.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation

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
        var places: PlaceDetails!

        //Parsing general root object
        if let results = jsonObj["result"] as? [String: Any]{
            
         
                if let place = PlaceDetails(json: results) {
                    places = place
                }
            }
        
        return places
    }
    
}
