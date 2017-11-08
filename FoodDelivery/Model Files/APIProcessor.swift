//
//  APIProcessor.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}

class ImageRequest {
    var decodeOperation: Operation?
    var request: DataRequest
    
    init(request: DataRequest) {
        self.request = request
    }
    
    func cancel() {
        decodeOperation?.cancel()
        request.cancel()
    }
}

class APIProcessor: NSObject {
    let baseURLString: String = "https://api.doordash.com/"
    static let shared = APIProcessor()
    
    let decodeQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue(label: "com.GlacierScenics.imageDecoder", attributes: .concurrent)
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
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
