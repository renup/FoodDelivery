//
//  AppCoordinator.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 10/31/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//AppCordinator coordinates actions between itself and its interactions with other coordinator classes

import Foundation
import UIKit

class AppCoordinator: NSObject {
    var navigationViewController: UINavigationController?

    init(_ navigationViewController: UINavigationController) {
       self.navigationViewController = navigationViewController
    }
    
    func start() {
        startMapCoordinator()
    }
    
    func startMapCoordinator() {
        guard let navigationVC = navigationViewController else {
            assertionFailure()
            return
        }
        
        let mapCoordinator = MapCoordinator(navigationVC)
        mapCoordinator.start()
    }
    
    
}
