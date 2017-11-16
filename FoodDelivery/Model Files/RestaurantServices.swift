//
//  Restaurant.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//Helper class to parse the JSON response of API call to fetch restaurants list.

import Foundation

class RestaurantServices: NSObject {
    var restaurantDictionary: NSDictionary?
    var restaurantID: String?
    var restaurantName: String?
    var cuisineType: String?
    var deliveryFee: String?
    var deliveryTime: String?
    var coverImageURL: String?
    //Question: if any of the values is null, what do we display?
    
    init(restaurantDictionary: NSDictionary) {
        super.init()
        
        self.restaurantDictionary = restaurantDictionary
        if let coverImageURL = restaurantDictionary["cover_img_url"] as? String {
            self.coverImageURL = coverImageURL
        }
                
        if let restaurantID = restaurantDictionary["id"] as? Int64 {
            self.restaurantID = String(describing: restaurantID)
        }
     
        if let businessDict: NSDictionary = restaurantDictionary["business"] as? NSDictionary {
            if let restaurantName = businessDict["name"] as? String {
                self.restaurantName = restaurantName
            }
        }
        
        if let cuisineType = restaurantDictionary["description"] as? String {
            self.cuisineType = cuisineType
        }
        
        if var fee: Double = restaurantDictionary["delivery_fee"] as? Double {
            if (fee > 0) {
                fee = fee/100.0
                deliveryFee = "$" + String(format:"%.2f", fee) + " delivery"
            } else {
                deliveryFee = "Free delivery"
            }
        }
       
        if let deliveryTime = restaurantDictionary["status"] as? String {
            self.deliveryTime = deliveryTime
        }
    }
}

