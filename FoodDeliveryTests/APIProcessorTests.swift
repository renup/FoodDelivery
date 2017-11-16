//
//  APIProcessorTests.swift
//  FoodDeliveryTests
//
//  Created by Renu Punjabi on 11/16/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import FoodDelivery

class APIProcessorTests: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("fetchRestaurantsList") {
            context("success"){
                it("returns json response array") {
                    var response: NSArray?
                    APIProcessor.shared.fetchRestaurantsList(coordinateX: "37.42274", coordinateY: "-122.139956", completionHandler: { (jsonResponse, error) in
                        response = jsonResponse
                    })
                    expect(response).toEventuallyNot(beNil(), timeout: 20)
                }
                
            }
            
        }
    }
    
}
