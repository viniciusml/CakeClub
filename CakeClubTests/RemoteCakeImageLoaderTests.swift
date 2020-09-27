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
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.requestedURLs.isEmpty)
    }

    func test_loadImage_requestsImageFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, view) = makeSUT(url: url)

        sut.loadImage(from: url, into: view)

        XCTAssertEqual(sut.requestedURLs, [url])
    }

    func test_loadImageTwice_requestsImageFromURLTwice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, view) = makeSUT(url: url)

        sut.loadImage(from: url, into: view)
        sut.loadImage(from: url, into: view)

        XCTAssertEqual(sut.requestedURLs, [url , url])
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: ImageLoaderStub, view: UIImageView) {
        let view = UIImageView()
        let sut = ImageLoaderStub()
        return (sut, view)
    }

    class ImageLoaderStub: CakeImageLoader {
        var requestedURLs = [URL]()

        func loadImage(from url: URL, into view: UIImageView) {
            requestedURLs.append(url)
        }
    }
}
