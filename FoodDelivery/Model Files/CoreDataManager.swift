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
    
    
    func checkIfRestaurantIsFavorited(restaurantIDToCheck : String) -> Bool!{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "restaurantID == \(restaurantIDToCheck)")
//
//        let keypathExp = NSExpression(forKeyPath: "restaurantID")
//        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
//
//        let countDesc = NSExpressionDescription()
//        countDesc.expression = expression
//        countDesc.name = "count"
//        countDesc.expressionResultType = .integer16AttributeType

        var retCount:Int = 0
        
        do {
            retCount = try managedContext.count(for: fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
        
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext)!
        
        let restaurantToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let store = restaurant as? RestaurantServices {
            if let storeDict = store.restaurantDictionary {
                restaurantToSave.setValue(storeDict, forKey: "restaurantDictionary")
            }
            if let storeName = store.restaurantName {
                restaurantToSave.setValue(storeName, forKeyPath: "restaurantName")
            }
            if let imageURLStr = store.coverImageURL {
                restaurantToSave.setValue(imageURLStr, forKeyPath: "coverImageURL")
            }
            if let storeId = store.restaurantID {
                restaurantToSave.setValue(storeId, forKey: "restaurantID")
            }
            if let deliveryTime = store.deliveryTime {
                restaurantToSave.setValue(deliveryTime, forKey: "deliveryTime")
            }
            if let deliveryFee = store.deliveryFee {
                restaurantToSave.setValue(deliveryFee, forKey: "deliveryFee")
            }
            if let cuisineType = store.cuisineType {
                restaurantToSave.setValue(cuisineType, forKey: "cuisineType")
            }
        }
        
        if let store = restaurant as? NSManagedObject {
            if let storeDict = store.value(forKeyPath: "restaurantDictionary") {
                restaurantToSave.setValue(storeDict, forKey: "restaurantDictionary")
            }
            if let storeName = store.value(forKeyPath: "restaurantName") {
                restaurantToSave.setValue(storeName, forKeyPath: "restaurantName")
            }
            if let imageURLStr = store.value(forKeyPath: "coverImageURL") {
                restaurantToSave.setValue(imageURLStr, forKeyPath: "coverImageURL")
            }
            if let storeId = store.value(forKeyPath: "restaurantID") {
                restaurantToSave.setValue(storeId, forKey: "restaurantID")
            }
            if let deliveryTime = store.value(forKeyPath: "deliveryTime") {
                restaurantToSave.setValue(deliveryTime, forKey: "deliveryTime")
            }
            if let deliveryFee = store.value(forKeyPath: "deliveryTime") {
                restaurantToSave.setValue(deliveryFee, forKey: "deliveryFee")
            }
            if let cuisineType = store.value(forKeyPath: "cuisineType") {
                restaurantToSave.setValue(cuisineType, forKey: "cuisineType")
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
