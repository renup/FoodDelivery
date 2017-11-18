//
//  MapViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 10/29/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//This viewController class manages taking in the user selection for loaction on the map view and passes that info to MapCoordinator for further actions

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: class {
    func getAddress(_ location: CLLocation, completionHandler: @escaping ((String) -> Void))
    func confirmUserChosenLocation(_ location: CLLocationCoordinate2D)
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let pin = MKPointAnnotation()
    var addressOfDesiredLocation = ""
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
        self.navigationItem.title = "Choose an Address"
        setUpLocationManager()
        addTapGestureToTheMap()
    }
    
    //MARK: Private methods
    
    private func addTapGestureToTheMap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: mapView)
        let newCoordinates = mapView.convert(location, toCoordinateFrom: mapView)
        let newLocation = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        populateAddressTextViewPerNewLocation(newLocation)
        centerMap(coordinates: newCoordinates, spanX: mapView.region.span.latitudeDelta, spanY: mapView.region.span.longitudeDelta)
    }
    
    private func populateAddressTextViewPerNewLocation(_ newLocation: CLLocation){
        delegate?.getAddress(newLocation, completionHandler: { (address) in
            self.addressTextView.textColor = UIColor.black
            
            if (address != self.addressOfDesiredLocation) {
                self.addressOfDesiredLocation = address
                self.addressTextView.text = address
            }
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    private func setUpLocationManager() {
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
    
    fileprivate func centerMap(coordinates: CLLocationCoordinate2D, spanX: Double?, spanY: Double?) {
        mapView.removeAnnotation(pin)
        myLocation = coordinates
        
        let deltaX = spanX ?? 0.05
        let deltaY = spanY ?? 0.05
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpanMake(deltaX, deltaY))
        mapView.setRegion(region, animated: true)
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
    }
    
    
    /// Handles logic for when address is confirmed in Map
    ///
    /// - Parameter sender: Location details from the map click
    @IBAction func confirmAddressButtonClicked(_ sender: Any) {
        guard myLocation != nil else {
            return
        }
        delegate?.confirmUserChosenLocation(myLocation!)
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            guard let newLocation = locations.first else {
                return
            }
        
        populateAddressTextViewPerNewLocation(newLocation)
        centerMap(coordinates: newLocation.coordinate, spanX: nil, spanY: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
            print("error:: \(error)")
        #endif
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

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

    }
}

