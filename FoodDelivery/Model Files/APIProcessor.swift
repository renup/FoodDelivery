//
//  APIProcessor.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//This class manages all the API Calls


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
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
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

    func fetchImageData(imageURLString: String, imageDownloadHandler: @escaping ((_ image: UIImage?) -> Void)) -> Request {
        //download image data using alamofire
        
       return Alamofire.request(imageURLString, method: .get).responseImage { (response) in
            if let image = response.result.value {
                print("image downloaded: \(image)")
                imageDownloadHandler(image)
                self.cache(image, for: imageURLString)
            } else {
                imageDownloadHandler(nil)
            }
        }
    }
    
    //MARK: = Image Caching
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }

}
