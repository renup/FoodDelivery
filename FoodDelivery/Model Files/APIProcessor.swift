//
//  APIProcessor.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import Alamofire

class APIProcessor: NSObject {
    let baseURLString: String = "https://api.doordash.com/"
    static let shared = APIProcessor()
    
    func fetchRestaurantsList(coordinateX: String, coordinateY: String, completionHandler: @escaping((_ response: NSArray?, _ error: NSError?) -> Void)) {
        let finalURLString = baseURLString + "v1/store_search/?" + "lat=" + coordinateX + "&lng=" + coordinateY
        Alamofire.request(finalURLString).validate().responseJSON { (response) in
            
            switch(response.result) {
            case .success: do {
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value as? NSArray {
                    print("JSON: \(json)") // serialized json response
                    completionHandler(json, nil)
                }
            }
            case .failure(let error):
                completionHandler([], error as NSError)
            }
        }
    }
}

func fetchImageData(imageURLString: String) -> UIImage {
    //download image data using alamofire
    return UIImage()
}
