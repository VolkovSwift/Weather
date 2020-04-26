//
//  UIAlertController + ext.swift
//  Weather
//
//  Created by user on 4/26/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}
