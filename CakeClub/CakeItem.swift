//
//  CakeItem.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

public typealias CakeList = [CakeItem]

public struct CakeItem: Codable, Equatable {
    public let title, desc: String
    public let image: URL

    public init(title: String, desc: String, image: URL) {
        self.title = title
        self.desc = desc
        self.image = image
    }
}
