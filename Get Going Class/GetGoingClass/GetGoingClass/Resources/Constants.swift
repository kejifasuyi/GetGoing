//
//  Constants.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-21.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation

class Constants {
    
    static let apiKey =
        "AIzaSyDGaul4-6D7e6tjVoftoOR-uD3Kj27w5G8"
    
    static let scheme = "https"
    static let host = "maps.googleapis.com"
    static let textPlaceSearch = "/maps/api/place/textsearch/json"
    static let nearbySearch = "/maps/api/place/nearbysearch/json"
    static let detailsSearch = "/maps/api/place/details/json"
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("PlaceDetails")
}
