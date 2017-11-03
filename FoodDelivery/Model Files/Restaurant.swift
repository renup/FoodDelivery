//
//  Restaurant.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation

class Restaurant: NSObject {
    var rawRestaurant: NSDictionary?
    var deliveryFee: Double?
    var restaurantName: String?
    var cuisineType: String?
    var deliveryTime: String?
    
    init(rawRestaurant: NSDictionary, deliveryFee: Double? = 0, restaurantName: String?, cuisineType: String?, deliveryTime: String?) {
        self.restaurantName = restaurantName
        self.deliveryFee = deliveryFee
        self.deliveryTime = deliveryTime
        self.cuisineType = cuisineType
        self.rawRestaurant = rawRestaurant
    }
    
}
