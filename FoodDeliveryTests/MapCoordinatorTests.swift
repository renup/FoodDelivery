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
        
        describe("MapCoordinator") {
            let nav = UINavigationController()
            var mapCoordinator: MapCoordinator!
            var restaurant: RestaurantServices?
            
            beforeEach {
                mapCoordinator = MapCoordinator(nav)
            }
        
        describe("fetchingDataCalls") {
                var response: [RestaurantServices]?
                
                context("restaurantListfetch"){
                    beforeEach {
                        let _ = self.stub(urlString: "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956" , jsonFileName: "restaurantListResponse")
                        mapCoordinator.fetchRestaurantList(latitude: "37.42274", longitude: "-122.139956", fetchCompleteHandler: { (restaurantList, error) in
                            guard restaurantList != nil else {
                                return
                            }
                            response = restaurantList
                            for item: RestaurantServices in (restaurantList)! {
                                if item.restaurantID == "45761" {
                                    restaurant = restaurantList?[(restaurantList?.index(of: item)!)!]
                                }
                            }
                        })
                    }
                    it("returns json 5 response array") {
                        expect(response).toEventuallyNot(beNil(), timeout: 20)
                        expect(response?.count) == 10
                        expect(restaurant?.restaurantName) == "Pizza My Heart"
                        expect(restaurant?.coverImageURL) == "https://cdn.doordash.com/media/restaurant/cover/Pizza-My-Heart.png"
                        expect(restaurant?.deliveryFee) == "Free delivery"
                        expect(restaurant?.cuisineType) == "Pizza"
                    }
                }
            
            context("menuCategoryFetch") {
                var menuArray = [String]()
                
                it("returns menu category items") {
                    
                    let _ = self.stub(urlString: "https://api.doordash.com/v2/restaurant/45761/menu/" , jsonFileName: "menuCategories")
                    if let store = restaurant {
                        mapCoordinator.fetchMenuCategories("45761", store, completionHandler: { (menu) in
                            if let foodCategory = menu {
                                menuArray = foodCategory.foodCategoryArray
                                
                                expect(menuArray).toEventuallyNot(beNil(), timeout: 20)
                                expect(menuArray.count) == 8
                                expect(menuArray.contains("Appetizers & Salads")) == true
                                expect(menuArray.contains("Vegetarian Specialty Pizzas")) == true
                            }
                        })
                    }
                    
                } //end of it statement for success context of fetchMenuCategories
            } // end of menu category context
   
        } //end of describe for fetch data
       
    } //end of MapCoordinator describe
    
}
}
