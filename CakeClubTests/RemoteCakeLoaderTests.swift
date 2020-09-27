//
//  RemoteCakeLoaderTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import XCTest

class RemoteCakeLoader {
    let url: URL
    let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteCakeLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (_, client) = makeSUT(url: url)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }

    // MARK: Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteCakeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCakeLoader(url: url, client: client)
        return (sut, client)
    }

    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

        func get(from url: URL) {
            requestedURL = url
        }
    }
}
