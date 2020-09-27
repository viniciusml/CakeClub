//
//  RemoteCakeImageLoader.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import SDWebImage
import UIKit

public class RemoteCakeImageLoader: CakeImageLoader {
    private var placeholderImage: UIImage? {
        UIImage(named: Constant.placeholderImageName)
    }

    public init() {}

    public func loadImage(from url: URL, into view: UIImageView) {
        view.sd_setImage(with: url, placeholderImage: placeholderImage, options: .highPriority)
    }
}
