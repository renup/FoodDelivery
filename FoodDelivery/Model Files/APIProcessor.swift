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
    
    func fetchRestaurantsList(coordinateX: String, coordinateY: String) {
        let finalURLString = baseURLString + "v1/store_search/?" + "lat=" + coordinateX + "&lng=" + coordinateY
        
        Alamofire.request(finalURLString).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
        }
    }
}
