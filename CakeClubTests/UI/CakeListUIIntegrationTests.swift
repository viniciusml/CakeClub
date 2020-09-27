//
//  CakeListUIIntegrationTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import XCTest

class CakeListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Would you have some cake?"
    }
}

class CakeListUIIntegrationTests: XCTestCase {

    func test_viewDidLoad_showsCorrectTitle() {
        let sut = CakeListViewController()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, "Would you have some cake?")
    }
}
