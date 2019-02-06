//
//  LocationService.swift
//  GetGoingClass
//
//  Created by Admin on 2019-01-30.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    //MARK: - Properties
    var locationManager: CLLocationManager?
    weak var delegate: LocationServiceDelegate?
    
    private override init() {
        super.init()
        
        locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager?.delegate = self
    }
    
    func startUpdatingLocation() {
      locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        delegate?.didUpdateLocation(location: location)
    }
}

protocol LocationServiceDelegate: class {
    func didUpdateLocation(location: CLLocation)
}
