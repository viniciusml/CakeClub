//
//  CakeCell+TestHelpers.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 03/10/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import UIKit

extension CakeCell {
    var cakeTitle: String? {
        titleLabel.text
    }

    var cakeDescription: String? {
        descriptionLabel.text
    }

    var cakeImage: UIImage? {
        cakeImageView.image
    }
}
