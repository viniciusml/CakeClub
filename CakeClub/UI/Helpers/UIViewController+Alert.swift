//
//  UIViewController+Alert.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

extension UIViewController {
    func showBasicAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: Constant.Text.alertOKAction, style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}
