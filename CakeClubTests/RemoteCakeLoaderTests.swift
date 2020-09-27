//
//  RemoteCakeLoaderTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import XCTest

class RemoteCakeLoader {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteCakeLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteCakeLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteCakeLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }

    // MARK: Helpers

    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

        func get(from url: URL) {
            requestedURL = url
        }
    }
}
