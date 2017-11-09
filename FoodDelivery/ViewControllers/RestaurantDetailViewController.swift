//
//  RestaurantDetailViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/8/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuLabel: UILabel!
    
    func configureCell(name: String) {
        menuLabel.text = name
    }
}

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var foodDeliveryLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var menuList: UITableView!
  
    var menuCategoryArray: [String]?
    
    var store: Restaurant?
    var restaurant: Restaurant? {
        set {
            store = newValue
        }
        get {
           return store
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
    }
    
    private func setUpViews() {
        if let urlStr = restaurant?.coverImageURL {
            restaurantImageView.image = APIProcessor.shared.cachedImage(for: urlStr)
          
        }
        
    }
    
    
    
    
    //MARK: IBActionMethods
    @IBAction func favoritesButtonClicked(_ sender: Any) {
        
    }
    
}

extension RestaurantDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let menuArray = menuCategoryArray {
            return menuArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        
        if let menuList = menuCategoryArray {
            menuCell.configureCell(name: menuList[indexPath.row])
        }
        return menuCell
    }
    
    
}
