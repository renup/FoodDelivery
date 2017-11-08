//
//  RestaurantsTableViewController.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/2/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

protocol RestaurantTableViewControllerDelegate: class {
    func userDidSelectAStore(restaurant: Restaurant)
    func popCurrentViewController()
}

class RestaurantsTableViewController: UITableViewController {
    fileprivate var restaurantArray: [Restaurant]?
    weak var delegate: RestaurantTableViewControllerDelegate?
    
    var storesArray: [Restaurant]? {
        
        didSet {
            //reload the tableview with new cell content info
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DoorDash"
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
        createBarButtonItems()
    }
    
    private func createBarButtonItems() {
        let searchImage : UIImage? = UIImage.init(named: "nav-search.png")!.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(self.searchBarButtonClicked))
        
        let addressImage : UIImage? = UIImage.init(named: "nav-address.png")!.withRenderingMode(.alwaysOriginal)


        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: addressImage, style: .plain, target: self, action: #selector(self.addressBarButtonClicked))
    }
    
    @objc private func searchBarButtonClicked() {
        
    }
    
    @objc private func addressBarButtonClicked() {
        delegate?.popCurrentViewController()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = storesArray {
            return array.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storeCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantCell
        
        if let restaurantArray = storesArray {
            storeCell.configureCell(restaurant: restaurantArray[indexPath.row])
        }
        
        return storeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let restaurantArray = storesArray {
            delegate?.userDidSelectAStore(restaurant: restaurantArray[indexPath.row])
        }
    }
   
}

