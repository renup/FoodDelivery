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

class MapCoordinatorTests: QuickSpec {
    
    override func spec() {
        super.spec()
        let nav = UINavigationController()
        let mapCoordinator = MapCoordinator(nav)
        
        describe("fetchRestaurantsList") {
            var response: [RestaurantServices]?
            var restaurant: RestaurantServices?

            beforeEach {
                response = nil
            }
            context("success"){
                
                beforeEach {
                    
                    let _ = self.stub(urlString: "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956", jsonFileName: "restaurantListResponse")
                    mapCoordinator.fetchRestaurantList(latitude: "37.42274", longitude: "-122.139956", fetchCompleteHandler: { (restaurantList, error) in
                        response = restaurantList
                        restaurant = restaurantList?[0]
                    })
                }
                
                it("returns json response array") {                    
                    expect(response).toEventuallyNot(beNil(), timeout: 20)
                    expect(response?.count) == 10
                    expect(restaurant?.restaurantName) == "Pizza My Heart"
                    expect(restaurant?.coverImageURL) == "https://cdn.doordash.com/media/restaurant/cover/Pizza-My-Heart.png"
                    expect(restaurant?.deliveryTime) == "29 mins"
                    expect(restaurant?.deliveryFee) == "Free delivery"
                    expect(restaurant?.cuisineType) == "Pizza"
                }
                
            }
            
        }
    }
    
}
