//
//  MenuCategory.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/8/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//Helper class to parse Menu category api call response and get the menu category items in an array to consume in menu category table view in detailVC

import Foundation

struct MenuCategory {
    var foodCategoryArray = [String]()

    init(menuDictionary: NSDictionary) {
        if let categoryArray = menuDictionary["menu_categories"] as? NSArray {
            for item in categoryArray {
                if let itemDictionary = item as? NSDictionary {
                    if let categoryName = itemDictionary["title"] as? String {
                        foodCategoryArray.append(categoryName)
                    }
                }
            }
        }
    }
    
}
