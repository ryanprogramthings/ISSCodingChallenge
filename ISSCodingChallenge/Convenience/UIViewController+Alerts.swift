//
//  UIViewController+Alerts.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

/* Extension to keep default alert logic. Could change this into a static class maybe in the future. */
extension UIViewController {
    static func alertController(for message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        return alert
    }
    
    static func authorizeLocationAlert() -> UIAlertController {
        return alertController(for: "Could not get location. If it is not turned on, please turn it on in your settings.")
    }
}
