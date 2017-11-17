//
//  CoreDataManager.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/10/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//Helper class to manage/perform actions on local coredata database 

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    /// Common method called by all fetch requests to get the managedobjectcontext instance
    ///
    /// - Returns: returns the managed object context
    private func getManagedObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    /// Fetches all Favorites restaurants from CoreData storage
    ///
    /// - Returns: returns an Array of NSManagedObjects from CoreData. It has all the restaurant objects
    func fetchAllFavoriteRestaurants() -> [NSManagedObject]?{
        var allFavoriteRestaurants: [NSManagedObject] = []
        
        let managedContext = getManagedObjectContext()
        
        if let context = managedContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
            do {
                allFavoriteRestaurants = try context.fetch(fetchRequest)
            } catch let error as NSError {
                #if DEBUG
                    print("Could not fetch. \(error), \(error.userInfo)")
                #endif
            }
        }

        return allFavoriteRestaurants
    }
    
    
    /// Checks to see if restaurant was previously favorited
    ///
    /// - Parameter restaurantIDToCheck: restaurant ID to check
    /// - Returns: returns Bool value indicating whether restaurant was previously favorited or not
    func checkIfRestaurantIsFavorited(restaurantIDToCheck : String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "restaurantID == \(restaurantIDToCheck)")
        
        var retCount:Int = 0
        
        let context = getManagedObjectContext()
        
        if let managedContext = context {
            do {
                retCount = try managedContext.count(for: fetchRequest)
            } catch let error as NSError {
                #if DEBUG
                    print("Could not fetch. \(error), \(error.userInfo)")
                #endif
            }
        }
 
        if (retCount == 0){
            #if DEBUG
                print("Found nothing for. \(restaurantIDToCheck)")
            #endif
            return false
        }
        else{
            #if DEBUG
                print("Found something for. \(restaurantIDToCheck)")
            #endif
            return true
        }
    }
    
    /// Save restaurant record to CoreData
    ///
    /// - Parameter restaurant: restaurant object to be saved into core data
    func saveFavoriteRestaurant (store: RestaurantServices) {

        let context = getManagedObjectContext()
        
        guard let managedContext = context else {
            assertionFailure()
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext) else {
            assertionFailure()
            return
        }
        
        let restaurantToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let storeDict = store.restaurantDictionary {
            restaurantToSave.setValue(storeDict, forKey: Constants.restaurantDictionary)
        }
        if let storeName = store.restaurantName {
            restaurantToSave.setValue(storeName, forKeyPath: Constants.restaurantName)
        }
        if let imageURLStr = store.coverImageURL {
            restaurantToSave.setValue(imageURLStr, forKeyPath: Constants.coverImageURL)
        }
        if let storeId = store.restaurantID {
            restaurantToSave.setValue(storeId, forKey: Constants.restaurantID)
        }
        if let deliveryTime = store.deliveryTime {
            restaurantToSave.setValue(deliveryTime, forKey:  Constants.deliveryTime)
        }
        if let deliveryFee = store.deliveryFee {
            restaurantToSave.setValue(deliveryFee, forKey: Constants.deliveryFee)
        }
        if let cuisineType = store.cuisineType {
            restaurantToSave.setValue(cuisineType, forKey: Constants.cuisineType)
        }
      
        
//        if let store = restaurant as? NSManagedObject {
//            if let storeDict = store.value(forKeyPath: Constants.restaurantDictionary) {
//                restaurantToSave.setValue(storeDict, forKey: Constants.restaurantDictionary)
//            }
//            if let storeName = store.value(forKeyPath: Constants.restaurantName) {
//                restaurantToSave.setValue(storeName, forKeyPath: Constants.restaurantName)
//            }
//            if let imageURLStr = store.value(forKeyPath: Constants.coverImageURL) {
//                restaurantToSave.setValue(imageURLStr, forKeyPath: Constants.coverImageURL)
//            }
//            if let storeId = store.value(forKeyPath: Constants.restaurantID) {
//                restaurantToSave.setValue(storeId, forKey: Constants.restaurantID)
//            }
//            if let deliveryTime = store.value(forKeyPath: Constants.deliveryTime) {
//                restaurantToSave.setValue(deliveryTime, forKey: Constants.deliveryTime)
//            }
//            if let deliveryFee = store.value(forKeyPath: Constants.deliveryFee) {
//                restaurantToSave.setValue(deliveryFee, forKey: Constants.deliveryFee)
//            }
//            if let cuisineType = store.value(forKeyPath: Constants.cuisineType) {
//                restaurantToSave.setValue(cuisineType, forKey: Constants.cuisineType)
//            }
//        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            #if DEBUG
                print("Could not save. \(error), \(error.userInfo)")
            #endif
        }
    }
    
    
}
