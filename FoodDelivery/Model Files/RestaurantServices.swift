//
//  Restaurant.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class Restaurant: NSObject {
    var restaurantDictionary: NSDictionary?
    var restaurantID: String?
    var restaurantName: String?
    var cuisineType: String?
    var deliveryFee: String?
    var deliveryTime: String?
    var coverImageURL: String?
    var coverImage: UIImage?
 
    //Question: if any of the values is null, what do we display?
    init(restaurantDictionary: NSDictionary) {
        super.init()
        
        self.restaurantDictionary = restaurantDictionary
        if let coverImageURL = restaurantDictionary["cover_img_url"] as? String {
            self.coverImageURL = coverImageURL
            
            APIProcessor.shared.fetchImageData(imageURLString: coverImageURL, imageDownloadHandler: {[unowned self] (image) in
                self.coverImage = image
            })
        }
                
        if let restaurantID = restaurantDictionary["id"] as? String {
            self.restaurantID = restaurantID
        }
     
        if let businessDict: NSDictionary = restaurantDictionary["business"] as? NSDictionary {
            if let restaurantName = businessDict["name"] as? String {
                self.restaurantName = restaurantName
            }
        }
        
        if let cuisineType = restaurantDictionary["description"] as? String {
            self.cuisineType = cuisineType
        }
        
        if let fee: Double = restaurantDictionary["delivery_fee"] as? Double {
            if (fee > 0.0) {
                deliveryFee = "$" + String(format:"%.1f", fee) + " delivery"
            } else {
                deliveryFee = "Free delivery"
            }
        }
       
        if let deliveryTime = restaurantDictionary["status"] as? String {
            self.deliveryTime = deliveryTime
        }
    }
}
