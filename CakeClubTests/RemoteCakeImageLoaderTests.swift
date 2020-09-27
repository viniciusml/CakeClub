//
//  RemoteCakeImageLoaderTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import XCTest

protocol CakeImageLoader {
    func loadImage(from url: URL, into view: UIImageView)
}

class RemoteCakeImageLoaderTests: XCTestCase {

    func test_init_doesNotRequestImageFromURL() {
        let loader = ImageLoaderStub()

        XCTAssertTrue(loader.requestedURLs.isEmpty)
    }

    func test_loadImage_requestsImageFromURL() {
        let url = URL(string: "https://a-url.com")!
        let loader = ImageLoaderStub()

        loader.loadImage(from: url, into: UIImageView())

        XCTAssertEqual(loader.requestedURLs, [url])
    }

    class ImageLoaderStub: CakeImageLoader {
        var requestedURLs = [URL]()

        func loadImage(from url: URL, into view: UIImageView) {
            requestedURLs.append(url)
        }
    }
}