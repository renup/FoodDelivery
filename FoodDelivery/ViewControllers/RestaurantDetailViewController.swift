//
//  RestaurantDetailViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/8/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//This class displays details about selected Restaurant and reports back any action on it to MapCoordinator for further actions

import Foundation
import UIKit
import CoreData

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuLabel: UILabel!
    
    func configureCell(name: String) {
        menuLabel.text = name
    }
}

protocol RestaurantDetailViewControllerDelegate: class {
    func userFavoritedTheRestaurant(store: Any)
}

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var foodDeliveryLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var menuList: UITableView!
    weak var delegate: RestaurantDetailViewControllerDelegate?
    
    var menuCategoryArray: [String]?
    var restaurantFavorited = false
    var store: Any?
    var restaurant: Any?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        setTheFavoriteButtonAppearance()
        menuList.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popViewController(animated: animated)
    }
    
    //MARK: Private methods
    
    private func setUpViews() {
        if let store = restaurant as? RestaurantServices {
            if let id = store.restaurantID {
                restaurantFavorited(storeID: id)
            }
            
            if let urlStr = store.coverImageURL {
                populateImageView(urlString: urlStr)
            }
            if let fee = store.deliveryFee, let time = store.deliveryTime {
                let deliveryMessage = fee + " in " + time
                foodDeliveryLabel.text = deliveryMessage
            }
        }
        if let store = restaurant as? NSManagedObject {
            if let id = store.value(forKeyPath: Constants.restaurantID) as? String {
                restaurantFavorited(storeID: id)
            }
            if let urlStr = store.value(forKeyPath: Constants.coverImageURL) as? String {
                populateImageView(urlString: urlStr)
            }
            if let fee = store.value(forKeyPath: Constants.deliveryFee) as? String, let time = store.value(forKeyPath: Constants.deliveryTime) as? String {
                let deliveryMessage = fee + " in " + time
                foodDeliveryLabel.text = deliveryMessage
            }
        }
    }
    
    private func restaurantFavorited(storeID: String) {
        if CoreDataManager.shared.checkIfRestaurantIsFavorited(restaurantIDToCheck: storeID) {
            restaurantFavorited = true
        } else {
            restaurantFavorited = false
        }
    }
    
    private func populateImageView(urlString: String) {
        if let cachedImage = APIProcessor.shared.cachedImage(for: urlString) {
            restaurantImageView.image = cachedImage
        } else {
            downloadImage(urlString: urlString)
        }
    }
    
    private func downloadImage(urlString: String) {
        let _ = APIProcessor.shared.fetchImageData(imageURLString: urlString, imageDownloadHandler: {[unowned self] (storeImage) in
            if let restaurantImage = storeImage {
                self.restaurantImageView.image = restaurantImage
            }
        })
    }
    
    private func setTheFavoriteButtonAppearance() {
        if restaurantFavorited {
            favoritesButton.backgroundColor = UIColor.red
            favoritesButton.setTitleColor(UIColor.white, for: .normal)
            favoritesButton.setTitle("Favorited", for: .normal)
        } else {
            favoritesButton.layer.borderColor = UIColor.red.cgColor
            favoritesButton.layer.borderWidth = 1.0
            favoritesButton.backgroundColor = UIColor.white
            favoritesButton.setTitleColor(UIColor.red, for: .normal)
            favoritesButton.setTitle("Add to Favorites", for: .normal)
        }
    }
    
    //MARK: IBActionMethods
    @IBAction func favoritesButtonClicked(_ sender: Any) {
        guard restaurant != nil else {
            assertionFailure()
            return
        }
        delegate?.userFavoritedTheRestaurant(store: restaurant!)
        restaurantFavorited = true
        setTheFavoriteButtonAppearance()
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
