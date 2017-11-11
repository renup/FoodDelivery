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
        let vc = MapViewController.instantiateUsingDefaultStoryboardIdWithStoryboardName(name: "Main")
        if let restorationID = self.restorationIdentifier {
            switch (restorationID) {
            case "favoritesNavController" :
                if let tableVC = vc as? RestaurantsTableViewController {
                    self.present(tableVC, animated: true, completion: nil)
                }
                break
            case "exploreNavController" :
                if let viewController = vc as? MapViewController {
                    self.present(viewController, animated: true, completion: nil)
                }
            default:
                if let viewController = vc as? MapViewController {
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
}
