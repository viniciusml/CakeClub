//
//  RemoteCakeImageLoaderTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest

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
        let (sut, view) = makeSUT()
        let placeholderImage = UIImage.makePlaceholder()

        ImageLoaderStub.stubError()
        sut.loadImage(from: anyURL(), into: view)

        XCTAssertEqual(view.image?.pngData(), placeholderImage.pngData())
    }

    func test_loadImage_deliversCorrectImageOnLoadingSuccess() {
        let (sut, view) = makeSUT()
        let expectedImage = UIImage.make(withColor: .red)

        ImageLoaderStub.stubImage(expectedImage)
        sut.loadImage(from: anyURL(), into: view)

        XCTAssertEqual(view.image?.pngData(), expectedImage.pngData())
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: ImageLoaderStub, view: UIImageView) {
        let view = UIImageView()
        let sut = ImageLoaderStub()
        return (sut, view)
    }

    private func anyURL() -> URL {
        URL(string: "https://a-url.com")!
    }

    class ImageLoaderStub: CakeImageLoader {
        var requestedURLs = [URL]()
        private static var image: UIImage?
        private var placeholderImage = UIImage.makePlaceholder()

        func loadImage(from url: URL, into view: UIImageView) {
            requestedURLs.append(url)
            guard let image = ImageLoaderStub.image else {
                view.image = placeholderImage
                return
            }
            view.image = image
        }

        static func stubError() {
            image = nil
        }

        static func stubImage(_ image: UIImage) {
            self.image = image
        }
    }
}
