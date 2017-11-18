//
//  RestaurantCell.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/8/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//Restaurant cell manages the configuration of restaurant data to be displayed to the user

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
    
    
    /// Configure the detailview cell with object of type NSManagedObject which holds restaurant details from CoreData
    ///
    /// - Parameter favoriteRestaurant: Restaurant object of type NSManagedObject
    func configureCellWith(favoriteRestaurant: NSManagedObject) {
        restaurantNameLabel.text = favoriteRestaurant.value(forKeyPath: Constants.restaurantName) as? String
        deliveryFeeLabel.text = favoriteRestaurant.value(forKeyPath: Constants.deliveryFee) as? String
        deliveryTimeLabel.text = favoriteRestaurant.value(forKeyPath: Constants.deliveryTime) as? String
        cuisineTypeLabel.text = favoriteRestaurant.value(forKeyPath: Constants.cuisineType) as? String
        
        if let imageURL = favoriteRestaurant.value(forKeyPath: Constants.coverImageURL) as? String {
            loadImage(urlString: imageURL)
        }   
    }
    
    /// Configure the detailview cell using a RestaurantServices object
    ///
    /// - Parameter restaurant: RestaurantServices object
    func configureCell(restaurant: RestaurantServices) {
        self.restaurant = restaurant
        
        deliveryFeeLabel.text = restaurant.deliveryFee
        deliveryTimeLabel.text = restaurant.deliveryTime
        cuisineTypeLabel.text = restaurant.cuisineType
        restaurantNameLabel.text = restaurant.restaurantName
        
        // Assigns a placeholder image for the cell
        guard let placeholderImage = UIImage(named: "food_icon.png"), let urlStr = restaurant.coverImageURL, let imgURL = URL(string: urlStr) else {
            return
        }
        coverImageView.af_setImage(withURL: imgURL, placeholderImage: placeholderImage)
        reset()
        loadImage(urlString: urlStr)
    }
    

    private func reset() {
        request?.cancel()
    }
    
    /// Loads the image from cache or server
    ///
    /// - Parameter urlString: URL for the image
    private func loadImage(urlString: String) {
        
        if let cachedImage = apiProcessor.cachedImage(for: urlString) {
            populateWithImage(image: cachedImage)
        } else {
            downloadImage(urlString: urlString)
        }
    }
    
    /// Downloads the image from server
    ///
    /// - Parameter urlString: URL for image
    private func downloadImage(urlString: String) {
        request = APIProcessor.shared.fetchImageData(imageURLString: urlString, imageDownloadHandler: {[unowned self] (storeImage) in
            if let restaurantImage = storeImage {
                self.populateWithImage(image: restaurantImage)
            }
        })
    }
    
    /// Populates the coverImageview with the image provided
    ///
    /// - Parameter image: image Object of type UIImage
    private func populateWithImage(image: UIImage) {
        coverImageView.image = image
    }
}
