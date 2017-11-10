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

protocol RestaurantDetailViewControllerDelegate: class {
    func userFavoritedTheRestaurant(store: RestaurantServices)
}

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var foodDeliveryLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var menuList: UITableView!
    weak var delegate: RestaurantDetailViewControllerDelegate?
    
    var menuCategoryArray: [String]?
    
    var store: RestaurantServices?
    var restaurant: RestaurantServices? {
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
        //TODO: check for cached image here or download it
        if let urlStr = restaurant?.coverImageURL {
            restaurantImageView.image = APIProcessor.shared.cachedImage(for: urlStr)
        }
        if let fee = restaurant?.deliveryFee, let time = restaurant?.deliveryTime {
            let deliveryMessage = fee + " in " + time
            foodDeliveryLabel.text = deliveryMessage
        }
    } 
    
    //MARK: IBActionMethods
    @IBAction func favoritesButtonClicked(_ sender: Any) {
        guard restaurant != nil else {
            assertionFailure()
            return
        }
        delegate?.userFavoritedTheRestaurant(store: restaurant!)
        favoritesButton.backgroundColor = UIColor.red
        favoritesButton.setTitleColor(UIColor.white, for: .normal)
        favoritesButton.setTitle("Favorited", for: .normal)
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
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        if let menuList = menuCategoryArray {
            menuCell.configureCell(name: menuList[indexPath.row])
        }
        return menuCell
    }
    
    
}
