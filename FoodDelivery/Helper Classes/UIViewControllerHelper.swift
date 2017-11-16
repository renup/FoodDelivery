//
//  UIViewControllerHelper.swift
//  FoodDelivery
//
//  Created by Renu Punjabi on 11/3/17.
//  Copyright © 2017 Renu Punjabi. All rights reserved.
//

//UIViewController convenience class to instantiate ViewController from storyboard

import Foundation
import UIKit

extension UIViewController {
    
    class func defaultNibName() -> String {
        return String(describing: self)
    }
    
    class func instantiateUsingDefaultStoryboardIdWithStoryboardName(name: String) -> UIViewController {
        return instantiateControllerFromStoryboard(name: name, identifier: defaultNibName())
    }
    
    class func instantiateControllerFromStoryboard(name: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
