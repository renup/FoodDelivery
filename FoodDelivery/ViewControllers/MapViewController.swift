//
//  MapViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 10/29/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    
    fileprivate func setUpLocationManager() {
        //Ask for permission, when in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coordinates = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coordinates, animated: true)
        }
    }
    
    // MARK - CLLocationManagerDelegate
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = self.locationManager.location?.coordinate {
            centerMap(coordinates: location)
        }
    }
    
    fileprivate func centerMap(coordinates: CLLocationCoordinate2D) {
        myLocation = coordinates
        let spanX = 0.007
        let spanY = 0.007
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(region, animated: true)
    }
}
