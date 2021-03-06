//
//  MapCoordinator.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 10/31/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//MapCoordinator class is the decision maker for all the actions taken in the screens(viewcontrollers) and in the showing of the Restaurant list/ favorite lists flow to the user

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
        showMapView()
    }
    
    fileprivate func showMapView() {
        mapViewController =
           navigationVC?.viewControllers.first as? MapViewController
        mapViewController?.delegate = self
    }
    
    /// Display restaurant detail view
    ///
    /// - Parameters:
    ///   - categoryArray: menu category array
    ///   - store: restaurant object
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
        
        //Grab the NavigationVC of the tab selected, and push the restaurantVC on the right nav stack
        if let itemSelected = tabBarViewController?.selectedIndex {
            if let viewControllerArray = tabBarViewController?.viewControllers {
                if let navVC = viewControllerArray[itemSelected] as? UINavigationController {
                    navVC.pushViewController(restaurantDetailViewController!, animated: true)
                }
            }
        }
    }
    
    /// Present tab bar
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
                restaurantsTableViewController?.delegate = self
            }
            tabBarViewController?.selectedViewController = navVC
        }
        
        tabBarViewController?.tabMenuDelegate = self
        navigationVC?.present(tabBarViewController!, animated: true, completion: nil)
    }

    /// Fetches retaurant list for longitude and latitude selected by user
    ///
    /// - Parameters:
    ///   - latitude: latitude of location selected by user
    ///   - longitude: longitude of location selected by user
    ///   - fetchCompleteHandler: handler for when response is received back from API
    func fetchRestaurantList(latitude: String, longitude: String, fetchCompleteHandler: @escaping ((_ list: [RestaurantServices]?, _ error: NSError?) -> Void)) {
        var restaurantList = [RestaurantServices]()
        APIProcessor.shared.fetchRestaurantsList(coordinateX: latitude, coordinateY: longitude, completionHandler: ({jsonResponse, error in
            if error != nil {
                //print the error
                //later add an alert view to show that something went wrong
                #if DEBUG
                    print("error while retrieving restaurant list: \(String(describing: error))")
                #endif
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
    
    /// Fetch restaurant list for requested coordinates
    ///
    /// - Parameters:
    ///   - lat: latitude
    ///   - lon: longitude
    private func makeRestaurantListRequestPerCoordinates(lat: String, lon: String) {
        showLoadingIndicator()
        fetchRestaurantList(latitude: lat, longitude: lon) { [unowned self] (restaurantsList, error) in
                if error == nil {
                    self.restaurantsTableViewController?.dataSource = restaurantsList
                }
                self.hideLoadingIndicator()
        }
    }
    
    /// Get Address for a given Location
    ///
    /// - Parameters:
    ///   - location: CLLocation parameter
    ///   - completionHandler: Contains address string
    func getAddress(_ location: CLLocation, completionHandler: @escaping ((String) -> Void)) {
        var address = ""

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                #if DEBUG
                    print("error = \(String(describing: error))")
                #endif
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

    /// Get store id for requested restaurant
    ///
    /// - Parameter store: restaurant object
    /// - Returns: restaurant id for the restaurant
    fileprivate func getStoreId(store: Any) -> String {
        var storeID = ""
        if let store = store as? RestaurantServices {
            if let id = store.restaurantID {
                storeID = id
            }
        } else {
            if let store = store as? NSManagedObject {
                if let id = store.value(forKeyPath: "restaurantID") as? String {
                    storeID = id
                }
            }
        }
        return storeID
    }
    
    /// Fetches menu categories for the chosen restaurant
    ///
    /// - Parameters:
    ///   - storeID: restaurant Id
    ///   - completionHandler: contains processed menu category object
    func fetchMenuCategories(_ storeID: String, completionHandler: @escaping (_ menuCategory: MenuCategory?) -> Void) {
        APIProcessor.shared.fetchMenuCategories(restaurantID: storeID, completionHandler: {(menuCategoryArray, error) in
            
            if let menuItem = menuCategoryArray?.firstObject as? NSDictionary {
                let menu = MenuCategory(menuDictionary: menuItem)
                completionHandler(menu)
            } else {
                completionHandler(nil)
                #if DEBUG
                    print("Error while fetching menu categories: \(String(describing: error))")
                #endif
            }
        })
    }
 
}

// MARK: - RestaurantDetailViewControllerDelegate methods
extension MapCoordinator: RestaurantDetailViewControllerDelegate {
    
    func userFavoritedTheRestaurant(restaurant: RestaurantServices) {
        CoreDataManager.shared.saveFavoriteRestaurant(store: restaurant)
    }
}

// MARK: - RestaurantTableViewControllerDelegate methods
extension MapCoordinator: RestaurantTableViewControllerDelegate {
    func userDidSelectAStore(restaurant: Any) {
        showLoadingIndicator()
        let storeID = getStoreId(store: restaurant)
        fetchMenuCategories(storeID) {[unowned self] (menu) in
            if let foodCategoryObj = menu {
                self.showRestaurantDetailView(categoryArray: foodCategoryObj.foodCategoryArray, store: restaurant)
            }
            self.hideLoadingIndicator()
        }
    }
    
    func popCurrentViewController() {
        if let _ = tabBarViewController {
            navigationVC?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - TabMenuControllerDelegate methods
extension MapCoordinator: TabMenuControllerDelegate {
    func userSelectedTab(_ tabTitle: String) {
        if tabTitle == "Explore" {
            makeRestaurantListRequestPerCoordinates(lat: latString, lon: lonString)
            
            if let navVC =  tabBarViewController?.viewControllers?.first as? UINavigationController {
                if let restaurantVC = navVC.viewControllers.first as? RestaurantsTableViewController {
                    restaurantsTableViewController = restaurantVC
                    restaurantsTableViewController?.delegate = self
                }
            }
            
        } else {
            if let navVC =  tabBarViewController?.viewControllers?.last as? UINavigationController {
                if let restaurantVC = navVC.viewControllers.first as? RestaurantsTableViewController {
                    restaurantsTableViewController = restaurantVC
                    restaurantsTableViewController?.delegate = self
                    
                    // fetches all the favorite restaurants from core data
                    CoreDataManager.shared.fetchAllFavoriteRestaurants(completionHandler: {(favoriteRestaurants) in
                        if favoriteRestaurants != nil {
                            restaurantVC.dataSource = favoriteRestaurants
                        }
                    })
                }
            }
        }
    }
}

extension MapCoordinator {
    fileprivate func showLoadingIndicator() {
        guard let mainWindow = UIApplication.shared.keyWindow  else {
            return
        }
        MBProgressHUD.showAdded(to: mainWindow, animated: true)
    }
    
    fileprivate func hideLoadingIndicator() {
        guard let mainWindow = UIApplication.shared.keyWindow  else {
            return
        }
        MBProgressHUD.hide(for: mainWindow, animated: true)
    }
}
    


