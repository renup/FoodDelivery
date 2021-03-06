//
//  RestaurantsTableViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//This class displays the list of Restaurants fetched for specific location to the user. It reports back any user interaction (selection of any restaurant) to MapCoordinator for further action (showing details about that restaurant)

import Foundation
import UIKit
import CoreData

protocol RestaurantTableViewControllerDelegate: class {
    func popCurrentViewController()
    func userDidSelectAStore(restaurant: Any) 
}

class RestaurantsTableViewController: UITableViewController {
    fileprivate var restaurantArray: [Restaurant]?
    weak var delegate: RestaurantTableViewControllerDelegate?
    
    var dataSource: [Any]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "DoorDash"
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
        createBarButtonItems()
    }
    
    /// Method creates the tab-bar buttons
    private func createBarButtonItems() {
        let searchImage : UIImage? = UIImage.init(named: "nav-search.png")!.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(self.searchBarButtonClicked))
        
        let addressImage : UIImage? = UIImage.init(named: "nav-address.png")!.withRenderingMode(.alwaysOriginal)


        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: addressImage, style: .plain, target: self, action: #selector(self.addressBarButtonClicked))
    }
    
    @objc private func searchBarButtonClicked() {
        //implement search functionality
    }
    
    @objc private func addressBarButtonClicked() {
       delegate?.popCurrentViewController()
    }
    
    //MARK: TableView Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = dataSource {
            return array.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storeCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantCell
        
        // Handles configuration of cell for RetaurantServicesObject
        // This is for the case where the restaurants are obtained from the server API call
        if let restaurantArray = dataSource as? [RestaurantServices] {
            storeCell.configureCell(restaurant: restaurantArray[indexPath.row])
        }
        else{
            // Handles configuration of cell for CoreData-NSManagedObject
            // This is for the case where the favorite restaurants are obtained from CoreData
            if let restaurantManagedObjectArray = dataSource as? [NSManagedObject] {
            storeCell.configureCellWith(favoriteRestaurant: restaurantManagedObjectArray[indexPath.row])
            }
        }
        
        return storeCell
    }
    
    
    //MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let restaurantArray = dataSource {
       delegate?.userDidSelectAStore(restaurant: restaurantArray[indexPath.row])
        }
    }
   
}


