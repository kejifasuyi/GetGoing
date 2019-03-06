//
//  MapPreviewViewController.swift
//  GetGoingClass
//
//  Created by Admin on 2019-03-01.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import MapKit

class MapPreviewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var place: [PlaceDetails]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapViewCoordinate()
    }
    
    
    func setMapViewCoordinate() {
        mapView.delegate = self
       
        let annotations = place.compactMap {(place:PlaceDetails) -> MKAnnotation? in
        
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            guard let coordinate = place.coordinate else { return nil }
            annotation.coordinate = coordinate
            return annotation
            }
        
        mapView.addAnnotations(annotations)
    }
    
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


extension MapPreviewViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusablePin")
        // allowing to show extra information in the pin view
        view.canShowCallout = true
        // "i" button
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.pinTintColor = UIColor.blue
        
        return view
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation
        
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        if let coordinate = location?.coordinate {
            location?.mapItem(coordinate: coordinate).openInMaps(launchOptions: launchingOptions)
        }
    }
}


extension MKAnnotation {
    func mapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
}

