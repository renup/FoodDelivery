//
//  BaseNavigationViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/10/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BaseNavigationViewController: UINavigationController {
    
    var exploreDataSource = [RestaurantServices]()
    var favoritesDataSource = [NSManagedObject]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initiateViewControllerBasedOnID()
    }
    
    func initiateViewControllerBasedOnID() {
        let vc = RestaurantsTableViewController.instantiateUsingDefaultStoryboardIdWithStoryboardName(name: "Main")
        
        guard let tableVC = vc as? RestaurantsTableViewController else {
            return
        }
        
        if let restorationID = self.restorationIdentifier {
            switch (restorationID) {
            case "favoritesNavController" :
                tableVC.dataSource = favoritesDataSource
                break
            case "exploreNavController" :
                tableVC.dataSource = exploreDataSource
            default:
                tableVC.dataSource = exploreDataSource
            }
        }
        
        self.present(tableVC, animated: true, completion: nil)

    }
    
    
    
}
