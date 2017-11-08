//
//  RestaurantsTableViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class RestaurantsTableViewController: UITableViewController {
    fileprivate var restaurantArray: [Restaurant]?
    
    var storesArray: [Restaurant]? {
        
        didSet {
            //reload the tableview with new cell content info
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = storesArray {
            return array.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storeCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantCell
        
        if let restaurantArray = storesArray {
            storeCell.configureCell(restaurant: restaurantArray[indexPath.row])
        }
        
        return storeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}


