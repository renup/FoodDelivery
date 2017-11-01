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

protocol MapViewControllerDelegate: class {
    func getAddress(_ location: CLLocation, completionHandler: @escaping ((String) -> Void))

}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var value: MapViewControllerDelegate?
    weak var delegate: MapViewControllerDelegate? {
        get {
            return value
        }
        set {
            value = newValue
        }
        
        
    }
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    let newPin = MKPointAnnotation()
    private var mapChangedFromUserInteraction = false

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("delegate = \(String(describing: delegate))")
        setUpLocationManager()
    }
    
    //MARK: Private methods
    
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
    
    fileprivate func centerMap(coordinates: CLLocationCoordinate2D) {
        myLocation = coordinates
        let spanX = 0.007
        let spanY = 0.007
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
    }
    
    // MARK - CLLocationManagerDelegate
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
 
       delegate?.getAddress(location, completionHandler: { (address) in
        self.addressTextView.textColor = UIColor.black
        self.addressTextView.text = address
        })

        if let coordinates = self.locationManager.location?.coordinate {
            centerMap(coordinates: coordinates)
        }
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            // user changed map region
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            // user changed map region
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let newCoordinates = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
            centerMap(coordinates: newCoordinates)
        }
    }
   
}

