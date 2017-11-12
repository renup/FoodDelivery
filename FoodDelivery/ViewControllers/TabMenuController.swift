//
//  TabMenuController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 10/29/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

protocol TabMenuControllerDelegate: class {
    func userSelectedTab(_ tabTitle: String)
}


class TabMenuController: UITabBarController {
    weak var tabMenuDelegate: TabMenuControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let itemName = item.title {
            tabMenuDelegate?.userSelectedTab(itemName)
        }
    }
}
