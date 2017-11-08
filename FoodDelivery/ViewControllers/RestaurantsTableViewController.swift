//
//  RestaurantsTableViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    func populateCell(restaurantData: Restaurant) {
        deliveryFeeLabel.text = restaurantData.deliveryFee
        deliveryTimeLabel.text = restaurantData.deliveryTime
        cuisineTypeLabel.text = restaurantData.cuisineType
        restaurantNameLabel.text = restaurantData.restaurantName
        
        if restaurantData.coverImage == nil {
            guard let placeholderImage = UIImage(named: "food_icon.png"), let urlStr = restaurantData.coverImageURL, let imgURL = URL(string: urlStr) else {
                return
            }
            coverImageView.af_setImage(withURL: imgURL, placeholderImage: placeholderImage)
        } else {
            coverImageView.image = restaurantData.coverImage
        }
    }
}

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
            storeCell.populateCell(restaurantData: restaurantArray[indexPath.row])
        }
        
        return storeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}


