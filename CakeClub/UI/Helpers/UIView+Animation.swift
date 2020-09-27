//
//  UIView+Animation.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn(at indexPath: IndexPath) {
        transform = CGAffineTransform(translationX: 0, y: 100 / 2)
        alpha = 0

        UIView.animate(
            withDuration: 0.4,
            delay: 0.03 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.alpha = 1
            })
    }
}
