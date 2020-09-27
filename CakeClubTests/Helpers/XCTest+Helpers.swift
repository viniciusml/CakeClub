//
//  XCTest+Helpers.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest

extension XCTestCase {
    func makeCake(_ id: Int) -> CakeItem {
        CakeItem(title: "Cake \(id)", desc: "Cake desc \(id)", image: URL(string: "https://cake-url-\(id).com")!)
    }
}
