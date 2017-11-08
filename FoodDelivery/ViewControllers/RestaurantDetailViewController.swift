//
//  RestaurantDetailViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/8/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var foodDeliveryLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var menuList: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: IBActionMethods
    @IBAction func favoritesButtonClicked(_ sender: Any) {
    }
    
    
}
