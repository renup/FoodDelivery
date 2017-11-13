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
import CoreData

class MapCoordinator: NSObject, MapViewControllerDelegate {
   
    fileprivate var navigationVC: UINavigationController?
    fileprivate var mapViewController: MapViewController?
    fileprivate var tabBarViewController: TabMenuController?
    fileprivate var restaurantsTableViewController: RestaurantsTableViewController?
    fileprivate var restaurantDetailViewController: RestaurantDetailViewController?
    
    fileprivate var latString = ""
    fileprivate var lonString = ""
    
    init(_ navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
    }
    
    func start() {
        observeNotifications()
        showMapView()
    }
    
    private func observeNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.userDidSelectAStore(restaurant:)), name: .RestaurantTableViewControllerUserDidSelectRestaurant, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(self.navigateToMapView), name: .RestaurantTableViewControllerUserTappedDismissButton, object: nil)
    }
    
    fileprivate func showMapView() {
        mapViewController =
           navigationVC?.viewControllers.first as? MapViewController
        mapViewController?.delegate = self
    }
    
    fileprivate func showRestaurantDetailView(categoryArray: [String], store: Any) {
        
        if restaurantDetailViewController == nil{
            guard let restaurantDetailVC = RestaurantDetailViewController.instantiateUsingDefaultStoryboardIdWithStoryboardName(name: "Main") as? RestaurantDetailViewController else {
                assertionFailure()
                return
            }
        restaurantDetailViewController = restaurantDetailVC
        }

        restaurantDetailViewController?.restaurant = store
        restaurantDetailViewController?.menuCategoryArray = categoryArray
        restaurantDetailViewController?.delegate = self
        
        if let itemSelected = tabBarViewController?.selectedIndex {
            if let viewControllerArray = tabBarViewController?.viewControllers {
                if let navVC = viewControllerArray[itemSelected] as? UINavigationController {
                    navVC.pushViewController(restaurantDetailViewController!, animated: true)
                }
            }
        }
    }
    
    fileprivate func initiateTabBar() {
        if (tabBarViewController == nil){
            guard let tabBarVC = TabMenuController.instantiateUsingDefaultStoryboardIdWithStoryboardName(name: "Main") as? TabMenuController else {
                assertionFailure()
                return
            }
            tabBarViewController = tabBarVC
        }
        
        if let navVC = tabBarViewController?.viewControllers?.first as? UINavigationController {
            if let restaurantVC = navVC.viewControllers.first as? RestaurantsTableViewController {
                restaurantsTableViewController = restaurantVC
            }
        }
        
        if let firstTabVC = tabBarViewController?.viewControllers?.first {
            tabBarViewController?.selectedViewController = firstTabVC
        }
        
        tabBarViewController?.tabMenuDelegate = self
        navigationVC?.present(tabBarViewController!, animated: true, completion: nil)
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
        initiateTabBar()
        latString = String(describing: location.latitude)
        lonString = String(describing: location.longitude)
        makeRestaurantListRequestPerCoordinates(lat: latString, lon: lonString)
    }
    
    private func makeRestaurantListRequestPerCoordinates(lat: String, lon: String) {
        let hud = MBProgressHUD.showAdded(to: (mapViewController?.view)!, animated: true)

        //if user chose a different location, make the api call to get resturant list
//        if (lat != latString || lon != lonString) {
            fetchRestaurantList(latitude: lat, longitude: lon) { [unowned self] (restaurantsList, error) in
                if error == nil {
                    self.restaurantsTableViewController?.dataSource = restaurantsList
                }
                hud.hide(animated: true)
            }
        //}
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
    
    //MARK: Notification methods
    @objc private func navigateToMapView() {
        if let _ = tabBarViewController {
            navigationVC?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func userDidSelectAStore(restaurant: Notification) {
        guard let restaurantObj = restaurant.object else {
            return
        }
        
        let progressHud = MBProgressHUD.showAdded(to: (self.restaurantsTableViewController?.view)!, animated: true)
        progressHud.label.text = "Loading"
        var storeID = ""
        
        if let store = restaurantObj as? RestaurantServices {
            if let id = store.restaurantID {
                storeID = id
            }
        } else {
            if let store = restaurantObj as? NSManagedObject {
                if let id = store.value(forKeyPath: "restaurantID") as? String {
                    storeID = id
                }
            }
        }
        
        APIProcessor.shared.fetchMenuCategories(restaurantID: storeID, completionHandler: {[unowned self] (menuCategoryArray, error) in
            if let menuItem = menuCategoryArray?.firstObject as? NSDictionary {
                let menu = MenuCategory(menuDictionary: menuItem)
                self.showRestaurantDetailView(categoryArray: menu.foodCategoryArray, store: restaurantObj)
            } else {
                print(String(describing: error))
            }
            progressHud.hide(animated: true)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MapCoordinator: RestaurantDetailViewControllerDelegate {
    func userFavoritedTheRestaurant(store: Any) {
        var restaurantAlreadySaved : Bool = false
        
        if let restaurant = store as? RestaurantServices {
            if let storeId = restaurant.restaurantID {
                restaurantAlreadySaved = CoreDataManager.shared.checkIfRestaurantIsFavorited(restaurantIDToCheck: storeId)
            }
        }
        
        if let restaurant = store as? NSManagedObject {
            if let storeId = restaurant.value(forKeyPath: "restaurantID") as? String {
                restaurantAlreadySaved = CoreDataManager.shared.checkIfRestaurantIsFavorited(restaurantIDToCheck: storeId)
            }
        }

        if (!restaurantAlreadySaved){
            CoreDataManager.shared.saveFavoriteRestaurant(restaurant: store)
        }
    }
}

extension MapCoordinator: TabMenuControllerDelegate {
    func userSelectedTab(_ tabTitle: String) {
        if tabTitle == "Favorites" {

        } else {
            makeRestaurantListRequestPerCoordinates(lat: latString, lon: lonString)
        }
    }
    
    
}
