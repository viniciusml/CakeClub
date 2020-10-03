//
//  CakeCellTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 03/10/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest

class CakeCellTests: XCTestCase {
    func test_init_doesNotRenderCakeInformation() {
        let sut = CakeCell()

        XCTAssertNil(sut.cakeTitle)
        XCTAssertNil(sut.cakeDescription)
        XCTAssertNil(sut.cakeImage)
    }

    func test_prepareForReuse_resetsContent() {
        let sut = CakeCell()
        sut.descriptionLabel.text = "Any description"
        sut.titleLabel.text = "Any title"
        sut.cakeImageView.image = UIImage.make(withColor: .red)

        sut.prepareForReuse()

        XCTAssertNil(sut.cakeTitle)
        XCTAssertNil(sut.cakeDescription)
        XCTAssertNil(sut.cakeImage)
    }
}
