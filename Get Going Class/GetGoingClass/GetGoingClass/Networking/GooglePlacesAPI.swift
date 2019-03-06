//
//  GooglePlacesAPI.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-21.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesAPI {
    
    class func requestPlaces(_ query: String, opennow: Bool?, completion:
        @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.host = Constants.host
        urlComponents.scheme = Constants.scheme
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        if opennow == true {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: opennow?.description))
        }
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data, let
                    jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                }
                else {
                    completion(status, nil)
                }
            }
        }
       
    }
    
    class func requestPlacesNearby(for coordinate: CLLocationCoordinate2D,
                                   radius: Double,
                                   _ query: String?,
                                   opennow: Bool?,
                                   rankby: String?,
                                   completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.host = Constants.host
        urlComponents.scheme = Constants.scheme
        urlComponents.path = Constants.nearbySearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "rankby", value: rankby),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        if let keyword = query {
            urlComponents.queryItems?.append(URLQueryItem(name: "keyword", value: keyword))
        }
        
        if opennow == true {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: opennow?.description))
        }
        
        if  rankby == "prominence" {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: "\(Int(radius))"))
        }
        
        if let url = urlComponents.url {
            print(url)
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data, let
                    jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                }
                else {
                    completion(status, nil)
                }
            }
        }
        
    }
    //Newly Added
    class func requestDetails(_ pid: String, completion:
        @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.host = Constants.host
        urlComponents.scheme = Constants.scheme
        urlComponents.path = Constants.detailsSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: Constants.apiKey),
            URLQueryItem(name: "placeid", value: pid)
        ]
        
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data, let
                    jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                }
                else {
                    completion(status, nil)
                }
            }
        }
    }
}
