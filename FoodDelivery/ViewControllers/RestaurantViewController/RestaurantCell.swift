//
//  RestaurantCell.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/8/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import CoreData

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var request: Request?
    var restaurant: RestaurantServices?
    var apiProcessor : APIProcessor { return .shared }
    
    func configureCellWith(favoriteRestaurant: NSManagedObject) {
        restaurantNameLabel.text = favoriteRestaurant.value(forKeyPath: "restaurantName") as? String
        deliveryFeeLabel.text = favoriteRestaurant.value(forKeyPath: "deliveryFee") as? String
        deliveryTimeLabel.text = favoriteRestaurant.value(forKeyPath: "deliveryTime") as? String
        cuisineTypeLabel.text = favoriteRestaurant.value(forKeyPath: "cuisineType") as? String
        
        if let imageURL = favoriteRestaurant.value(forKeyPath: "coverImageURL") as? String {
            loadImage(urlString: imageURL)
        }   
    }
    
    func configureCell(restaurant: RestaurantServices) {
        self.restaurant = restaurant
        
        deliveryFeeLabel.text = restaurant.deliveryFee
        deliveryTimeLabel.text = restaurant.deliveryTime
        cuisineTypeLabel.text = restaurant.cuisineType
        restaurantNameLabel.text = restaurant.restaurantName
        
        guard let placeholderImage = UIImage(named: "food_icon.png"), let urlStr = restaurant.coverImageURL, let imgURL = URL(string: urlStr) else {
            return
        }
        coverImageView.af_setImage(withURL: imgURL, placeholderImage: placeholderImage)
        reset()
        loadImage(urlString: urlStr)
    }
    
    fileprivate func reset() {
        request?.cancel()
    }
    
    fileprivate func loadImage(urlString: String) {
        
        if let cachedImage = apiProcessor.cachedImage(for: urlString) {
            populateWithImage(image: cachedImage)
        } else {
            downloadImage(urlString: urlString)
        }
    }
    
    fileprivate func downloadImage(urlString: String) {
        request = APIProcessor.shared.fetchImageData(imageURLString: urlString, imageDownloadHandler: {[unowned self] (storeImage) in
            if let restaurantImage = storeImage {
                self.populateWithImage(image: restaurantImage)
            }
        })
    }
    
    fileprivate func populateWithImage(image: UIImage) {
        coverImageView.image = image
    }
}
