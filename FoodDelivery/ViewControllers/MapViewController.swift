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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
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
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mapChangedFromUserInteraction {
            if let touch = touches.first {
                let newCoordinates = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
                centerMap(coordinates: newCoordinates, spanX: mapView.region.span.latitudeDelta, spanY: mapView.region.span.longitudeDelta)
            }
        }
    }
}

extension MapViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        addressOfDesiredLocation = textView.text
    }
}


extension MapViewController: MKMapViewDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if mapChangedFromUserInteraction {
            locationManager.stopUpdatingLocation()
        } else {
            guard let newLocation = locations.first else {
                return
            }
            
            delegate?.getAddress(newLocation, completionHandler: { (address) in
                self.addressTextView.textColor = UIColor.black
                
                if (address != self.addressOfDesiredLocation) {
                    self.addressOfDesiredLocation = address
                }
            })
            centerMap(coordinates: newLocation.coordinate, spanX: nil, spanY: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
   
   // https://stackoverflow.com/questions/34772163/how-to-detect-the-mapview-was-moved-in-swift-and-update-zoom
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
            print("user WILL change map.")
            
            // calculate the width of the map in miles.
            let mRect: MKMapRect = mapView.visibleMapRect
            let eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect))
            let westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect))
            let currentDistWideInMeters = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint)
            let milesWide = currentDistWideInMeters / 1609.34  // number of meters in a mile
            print(milesWide)
            print("^miles wide")
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            // user changed map region
            print("user CHANGED map.")
            print(mapView.region.span.latitudeDelta)
            print(mapView.region.span.longitudeDelta)
            
            // calculate the width of the map in miles.
            let mRect: MKMapRect = mapView.visibleMapRect
            let eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect))
            let westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect))
            let currentDistWideInMeters = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint)
            let milesWide = currentDistWideInMeters / 1609.34  // number of meters in a mile
            print(milesWide)
            print("^miles wide")
        }
    }
}

