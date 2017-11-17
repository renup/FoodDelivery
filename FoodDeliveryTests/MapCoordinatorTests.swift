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
            var urlStr = ""
            var jsonFile = ""
            
            beforeEach {
                restaurant = nil
                mapCoordinator = MapCoordinator(nav)
            }
            
            describe("fetchRestaurantsList") {
                var response: [RestaurantServices]?
                urlStr = "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956"
                jsonFile = "restaurantListResponse"
                
                beforeEach {
                    response = nil
                }
                context("success"){
                    
                    beforeEach {
                        let _ = self.stub(urlString: urlStr , jsonFileName: jsonFile)
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
                    
                    it("returns json response array") {
                        expect(response).toEventuallyNot(beNil(), timeout: 20)
                        expect(response?.count) == 10
                        expect(restaurant?.restaurantName) == "Pizza My Heart"
                        expect(restaurant?.coverImageURL) == "https://cdn.doordash.com/media/restaurant/cover/Pizza-My-Heart.png"
                        expect(restaurant?.deliveryFee) == "Free delivery"
                        expect(restaurant?.cuisineType) == "Pizza"
                    }
                }
            }
            
            describe("fetchMenuCategories") {
               urlStr = "https://api.doordash.com/v2/restaurant/45761/menu/"
                jsonFile = "menuCategories"
                var menuArray = [String]()
                context("success") {
                    beforeEach {
                        let _ = self.stub(urlString: urlStr , jsonFileName: jsonFile)
                        if let store = restaurant {
                            mapCoordinator.fetchMenuCategories("45761", store, completionHandler: { (menu) in
                                if let foodCategory = menu {
                                    menuArray = foodCategory.foodCategoryArray
                                }
                            })
                        }
                       
                        it("returns menu category items") {
                            expect(menuArray).toEventuallyNot(beNil(), timeout: 20)
                            expect(menuArray.count) == 8
                            expect(menuArray.contains("Appetizers & Salads")) == true
                            expect(menuArray.contains("Vegetarian Specialty Pizzas")) == true
                        } //end of it statement for success context of fetchMenuCategories
                        
                    }
                }
            }
        }
            
            
        } //end of MapCoordinator describe

        
}
