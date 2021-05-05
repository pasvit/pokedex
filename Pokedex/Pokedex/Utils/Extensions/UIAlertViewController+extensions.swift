//
//  UIAlertViewController+extensions.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import UIKit

extension UIAlertController {
    static func showError(title: String? = "Error", message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            
            if let topViewController = UIApplication.topViewController() {
                if !topViewController.isKind(of: UIAlertController.self) {
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
