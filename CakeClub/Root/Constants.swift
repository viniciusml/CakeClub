//
//  Constants.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public struct Constant {
    public static let endpoint = "https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"

    public static let placeholderImageName = "cake-placeholder"

    struct Color {
        static var pink: UIColor { UIColor(red: 243/255, green: 177/255, blue: 191/255, alpha: 1.0) }
        static var yellow: UIColor { UIColor(red: 245/255, green: 212/255, blue: 156/255, alpha: 1.0) }
        static var blue: UIColor { UIColor(red: 142/255, green: 161/255, blue: 221/255, alpha: 1.0) }
    }

    struct Text {
        static let alertTitle = "Alert"
        static let alertMessage = "Something went wrong. Please try again."
        static let alertOKAction = "OK"
        static let listControllerTitle = "Would you have some cake?"
    }
}
