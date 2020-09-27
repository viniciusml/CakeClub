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

    func test_loadImage_deliversPlaceholdeImageOnLoadingError() {
        let url = URL(string: "https://a-url.com")!
        let (sut, view) = makeSUT(url: url)
        let placeholderImage = UIImage(named: "cake-placeholder")

        ImageLoaderStub.stubError()
        sut.loadImage(from: url, into: view)

        XCTAssertEqual(view.image?.pngData(), placeholderImage?.pngData())
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: ImageLoaderStub, view: UIImageView) {
        let view = UIImageView()
        let sut = ImageLoaderStub()
        return (sut, view)
    }

    class ImageLoaderStub: CakeImageLoader {
        var requestedURLs = [URL]()
        private static var image: UIImage?
        private var placeholderImage: UIImage? {
            UIImage(named: "cake-placeholder")
        }

        func loadImage(from url: URL, into view: UIImageView) {
            if ImageLoaderStub.image == nil {
                view.image = placeholderImage
            }
            requestedURLs.append(url)
        }

        static func stubError() {
            image = nil
        }
    }
}
