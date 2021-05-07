//
//  UIApplication+extensions.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import UIKit

extension UIApplication {
    class func topViewController() -> UIViewController? {
        var topvc = UIApplication.shared.keyWindow?.rootViewController
        guard topvc != nil else { return nil }
        
        while topvc?.presentedViewController != nil {
            topvc = topvc?.presentedViewController
        }
        return topvc
    }
}
