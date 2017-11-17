//
//  XCTest+Extensions.swift
//  FoodDeliveryTests
//
//  Created by Renu Punjabi on 11/16/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Mockingjay
import XCTest

extension XCTest {
    public func stub(urlString: String, jsonFileName: String) -> Mockingjay.Stub {
        let path = Bundle(for:  MapCoordinatorTests.self).path(forResource: jsonFileName, ofType: "json")!
    let data = NSData(contentsOfFile: path)!
        return stub(uri(urlString), jsonData(data as Data))
    }
    
    public func stub(urlString: String, error: NSError) -> Mockingjay.Stub {
        return stub(uri(urlString), failure(error))
    }

}
