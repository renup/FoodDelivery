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
    
    private func getManagedObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchAllFavoriteRestaurants() -> [NSManagedObject]?{
        var allFavoriteRestaurants: [NSManagedObject] = []
        
        let managedContext = getManagedObjectContext()
        
        if let context = managedContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
            do {
                allFavoriteRestaurants = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }

        return allFavoriteRestaurants
    }
    
    
    func checkIfRestaurantIsFavorited(restaurantIDToCheck : String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "restaurantID == \(restaurantIDToCheck)")
        
        var retCount:Int = 0
        
        let context = getManagedObjectContext()
        
        if let managedContext = context {
            do {
                retCount = try managedContext.count(for: fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
 
        if (retCount == 0){
            print("Found nothing for. \(restaurantIDToCheck)")
            return false
        }
        else{
            print("Found something for. \(restaurantIDToCheck)")
            return true
        }
    }
    
    func saveFavoriteRestaurant (restaurant: Any) {

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
        
        if let store = restaurant as? RestaurantServices {
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
        }
        
        if let store = restaurant as? NSManagedObject {
            if let storeDict = store.value(forKeyPath: Constants.restaurantDictionary) {
                restaurantToSave.setValue(storeDict, forKey: Constants.restaurantDictionary)
            }
            if let storeName = store.value(forKeyPath: Constants.restaurantName) {
                restaurantToSave.setValue(storeName, forKeyPath: Constants.restaurantName)
            }
            if let imageURLStr = store.value(forKeyPath: Constants.coverImageURL) {
                restaurantToSave.setValue(imageURLStr, forKeyPath: Constants.coverImageURL)
            }
            if let storeId = store.value(forKeyPath: Constants.restaurantID) {
                restaurantToSave.setValue(storeId, forKey: Constants.restaurantID)
            }
            if let deliveryTime = store.value(forKeyPath: Constants.deliveryTime) {
                restaurantToSave.setValue(deliveryTime, forKey: Constants.deliveryTime)
            }
            if let deliveryFee = store.value(forKeyPath: Constants.deliveryFee) {
                restaurantToSave.setValue(deliveryFee, forKey: Constants.deliveryFee)
            }
            if let cuisineType = store.value(forKeyPath: Constants.cuisineType) {
                restaurantToSave.setValue(cuisineType, forKey: Constants.cuisineType)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
