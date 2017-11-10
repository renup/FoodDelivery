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
   
    fileprivate var navigationVC: UINavigationController?
    fileprivate var mapViewController: MapViewController?
    fileprivate var restaurantsTableViewController: RestaurantsTableViewController?
    
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
    
    fileprivate func showRestaurantDetailView(categoryArray: [String], store: RestaurantServices) {
        guard let restaurantDetailVC = RestaurantDetailViewController.instantiateUsingDefaultStoryboardIdWithStoryboardName(name: "Restaurants") as? RestaurantDetailViewController else {
            assertionFailure()
            return
        }
        restaurantDetailVC.restaurant = store
        restaurantDetailVC.menuCategoryArray = categoryArray
        navigationVC?.pushViewController(restaurantDetailVC, animated: true)
    }
    
    fileprivate func showRestaurantListView() {
        guard let restaurantsTableViewController = RestaurantsTableViewController.instantiateUsingDefaultStoryboardIdWithStoryboardName(name: "Restaurants") as? RestaurantsTableViewController
            
            else {
            assertionFailure()
            return
        }
          
        self.restaurantsTableViewController = restaurantsTableViewController
        self.restaurantsTableViewController?.delegate = self
        navigationVC?.pushViewController(restaurantsTableViewController, animated: true)
    }
    
    fileprivate func fetchRestaurantList(latitude: String, longitude: String, fetchCompleteHandler: @escaping ((_ list: [RestaurantServices]?, _ error: NSError?) -> Void)) {
        var restaurantList = [RestaurantServices]()
        
        APIProcessor.shared.fetchRestaurantsList(coordinateX: latitude, coordinateY: longitude, completionHandler: ({jsonResponse, error in
            if error != nil {
                //for now print the error
                //later add an alert view to show tht something went wrong
                print("error while retrieving restaurant list: \(String(describing: error))")
                fetchCompleteHandler(nil, error)
            } else {
                if let json = jsonResponse {
                    for restaurant in json {
                        if let storeDictionary = restaurant as? NSDictionary {
                            let store = RestaurantServices(restaurantDictionary:storeDictionary)
                            restaurantList.append(store) //parsed and ready to use restaurant info
                        }
                    }// end of for
                }//end of if let
                fetchCompleteHandler(restaurantList, nil)
            }
        })
        )//api processor fetch call block end
    }
    
    //MARK: MapViewControllerDelegate methods
    func confirmUserChosenLocation(_ location: CLLocationCoordinate2D) {
        let hud = MBProgressHUD.showAdded(to: (mapViewController?.view)!, animated: true)
        self.showRestaurantListView()

        let lat = String(describing: location.latitude)
        let lon = String(describing: location.longitude)

        fetchRestaurantList(latitude: lat, longitude: lon) { [unowned self] (restaurantsList, error) in
            //Start activity indicator
            if error == nil {
                self.restaurantsTableViewController?.storesArray = restaurantsList
            }
            hud.hide(animated: true)
        }
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
    
    //MARK: RestaurantVC delegate methods
extension MapCoordinator: RestaurantTableViewControllerDelegate {
    
    func userDidSelectAStore(restaurant: RestaurantServices) {
        if let id = restaurant.restaurantID {
            let progressHud = MBProgressHUD.showAdded(to: (self.restaurantsTableViewController?.view)!, animated: true)
           progressHud.label.text = "Loading"
            APIProcessor.shared.fetchMenuCategories(restaurantID: id, completionHandler: {[unowned self] (menuCategoryArray, error) in
                if let menuItem = menuCategoryArray?.firstObject as? NSDictionary {
                    let menu = MenuCategory(menuDictionary: menuItem)
                    self.showRestaurantDetailView(categoryArray: menu.foodCategoryArray, store: restaurant)
                } else {
                    print(String(describing: error))
                }
                progressHud.hide(animated: true)
            })
        }
    }
    
    func popCurrentViewController() {
        self.navigationVC?.popViewController(animated: true)
    }
    
}
