//
//  CoreDataManager.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/10/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    func fetchAllFavoriteRestaurants() -> [NSManagedObject]?{
        
        var allFavoriteRestaurants: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        do {
            allFavoriteRestaurants = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return allFavoriteRestaurants
    }
    
    
    func saveFavoriteRestaurant (restaurant: RestaurantServices) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext)!
        
        let restaurantToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let storeDict = restaurant.restaurantDictionary {
            restaurantToSave.setValue(storeDict, forKey: "restaurantDictionary")
        }
        if let storeName = restaurant.restaurantName {
            restaurantToSave.setValue(storeName, forKeyPath: "restaurantName")
        }
        if let imageURLStr = restaurant.coverImageURL {
            restaurantToSave.setValue(imageURLStr, forKeyPath: "coverImageURL")
        }
        if let storeId = restaurant.restaurantID {
            restaurantToSave.setValue(storeId, forKey: "restaurantID")
        }
        if let deliveryTime = restaurant.deliveryTime {
            restaurantToSave.setValue(deliveryTime, forKey: "deliveryTime")
        }
        if let deliveryFee = restaurant.deliveryFee {
            restaurantToSave.setValue(deliveryFee, forKey: "deliveryFee")
        }
        if let cuisineType = restaurant.cuisineType {
            restaurantToSave.setValue(cuisineType, forKey: "cuisineType")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
