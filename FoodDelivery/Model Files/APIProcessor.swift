//
//  APIProcessor.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//This class manages all the Network API Calls


import Foundation
import Alamofire
import AlamofireImage

extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}

class APIProcessor: NSObject {
    let baseURLString: String = "https://api.doordash.com/"
    static let shared = APIProcessor()
    
    // specifying cache size for managing the images
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    /// Fetches Menu Categories for the given resturant
    ///
    /// - Parameters:
    ///   - restaurantID: resturant ID String
    ///   - completionHandler: Handler contains jsonResponse array and error
    func fetchMenuCategories(restaurantID: String, completionHandler: @escaping((_ menuArray: NSArray?, _ error: NSError?) -> Void)) {
        
        let finalURLString = baseURLString + "v2/restaurant/" + restaurantID + "/menu/"
        
        Alamofire.request(finalURLString, method: .get).validate().responseJSON { (response) in
            switch(response.result) {
            case .success :
                if let json = response.result.value as? NSArray {
                    print("MenuCategory JSON: \(json)")
                    completionHandler(json, nil)
                }
            case .failure(let error) :
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    /// Fetches list of Restaurants for the given location (coordinates)
    ///
    /// - Parameters:
    ///   - coordinateX: Latitude String
    ///   - coordinateY: Longitude String
    ///   - completionHandler: Handler contains jsonResponse array and error
    func fetchRestaurantsList(coordinateX: String, coordinateY: String, completionHandler: @escaping((_ response: NSArray?, _ error: NSError?) -> Void)) {
        let finalURLString = baseURLString + "v1/store_search/?" + "lat=" + coordinateX + "&lng=" + coordinateY
        Alamofire.request(finalURLString, method: .get).validate().responseJSON { (response) in
            
            switch(response.result) {
            case .success: do {
                print(String(describing: response))
                
                if let json = response.result.value as? NSArray {
                    print("Restaurant JSON: \(json)") // serialized json response
                    completionHandler(json, nil)
                }
            }
            case .failure(let error):
                completionHandler([], error as NSError)
            }
        }
    }

    /// Fetches Images for a restaurant
    ///
    /// - Parameters:
    ///   - imageURLString: restaurant Image URL String
    ///   - imageDownloadHandler: Handler contains jsonResponse array and error
    /// - Returns: returns a UIImage object for the restaurant
    func fetchImageData(imageURLString: String, imageDownloadHandler: @escaping ((_ image: UIImage?) -> Void)) -> Request {
        //download image data using alamofire
        
       return Alamofire.request(imageURLString, method: .get).responseImage { (response) in
            if let image = response.result.value {
                imageDownloadHandler(image)
                self.cache(image, for: imageURLString)
            } else {
                imageDownloadHandler(nil)
            }
        }
    }
    
    /// Saves an image to the memory cache
    ///
    /// - Parameters:
    ///   - image: Image object to be saved to cache
    ///   - url: URL string to be associated with the image being saved to cache
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    
    /// Returns cached image for the URL string provided
    ///
    /// - Parameter url: url string associated with the cached image
    /// - Returns: returns an Image object from the cache
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }

}
