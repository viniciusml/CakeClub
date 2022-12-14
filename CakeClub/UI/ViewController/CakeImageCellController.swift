//
//  CakeImageCellController.swift
//  CakeClub
//
//  Created by Vinicius Leal on 14/12/2022.
//  Copyright © 2022 Vinicius Leal. All rights reserved.
//

import UIKit

final class CakeImageCellController {
    private let model: CakeItem
    private let imageLoader: CakeImageLoader
    
    init(model: CakeItem, imageLoader: CakeImageLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UITableViewCell {
        let cell = CakeCell()
        //        cell.setBackgroundColor(for: indexPath)
        cell.titleLabel.text = model.title
        cell.descriptionLabel.text = model.desc
        imageLoader.loadImage(from: model.image, into: cell.cakeImageView)
        return cell
    }
}
