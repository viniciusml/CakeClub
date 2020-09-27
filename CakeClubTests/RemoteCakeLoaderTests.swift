//
//  RemoteCakeLoaderTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import XCTest

class RemoteCakeLoader {}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteCakeLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteCakeLoader()

        XCTAssertNil(client.requestedURL)
    }
}
