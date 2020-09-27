//
//  CakeImageLoader.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public protocol CakeImageLoader {
    typealias CompletionHandler = (() -> Void)?
    
    func loadImage(from url: URL, into view: UIImageView, completion: CompletionHandler)
}
