//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func alert(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .dark
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        return alertController
    }
}
