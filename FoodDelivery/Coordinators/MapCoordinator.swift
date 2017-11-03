//
//  MapCoordinator.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 10/31/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapCoordinator: NSObject, MapViewControllerDelegate {
   
    var delegate: MapViewControllerDelegate?
    var navigationVC: UINavigationController?
    var mapViewController: MapViewController?
    
    init(_ navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
    }
    
    func start() {
        showMapView()
    }
    
    fileprivate func showMapView() {
        mapViewController =
           navigationVC?.viewControllers.first as? MapViewController
        mapViewController?.delegate = self
    }
    
    //MARK: MapViewControllerDelegate methods
    
    func confirmUserChosenLocation(_ location: CLLocationCoordinate2D) {
        let lat = String(describing: location.latitude)
        let lon = String(describing: location.longitude)
        APIProcessor.shared.fetchRestaurantsList(coordinateX: lat, coordinateY: lon)
    }
    
    func getAddress(_ location: CLLocation, completionHandler: @escaping ((String) -> Void)) {
        var address = ""

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                print("error = \(String(describing: error))")
            } else {
                guard let placemark = placemarks?.first else {
                    return
                }
                address = ""
                
                if let subStreet = placemark.subThoroughfare {
                    address = address + subStreet + " "
                }
                
                if let streetName = placemark.thoroughfare {
                    address = address + streetName + ", "
                }
                
                if let city = placemark.locality {
                    address = address + city + ", "
                }
                
                if let state = placemark.administrativeArea {
                    address = address + state + ", "
                }
                
                if let county = placemark.subAdministrativeArea {
                    address = address + county + ", "
                }
                
                if let zip = placemark.postalCode {
                    address = address + zip + ", "
                }
                
                if let country = placemark.country {
                    address = address + country + ", "
                }
            }
            completionHandler(address)
        }
    }
}
