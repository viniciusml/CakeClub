//
//  RemoteCakeLoaderTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest

class RemoteCakeLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (_, client) = makeSUT(url: url)

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.HTTPClientError), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversNoItemsOnSuccessfulResponseWithEmptyList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            client.complete(with: [])
        })
    }

    func test_load_deliversItemsOnSuccessfulResponseWithItems() {
        let cakeList = [makeCake(1), makeCake(2), makeCake(3)]

        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success(cakeList), when: {
            client.complete(with: cakeList)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-url.com")!
        var sut: RemoteCakeLoader? = RemoteCakeLoader(url: url, client: client)

        var capturedResults = [RemoteCakeLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(with: [])

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteCakeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCakeLoader(url: url, client: client)
        return (sut, client)
    }

    private func expect(_ sut: RemoteCakeLoader, toCompleteWith result: CakeLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {

        var capturedResults = [CakeLoader.Result]()
        sut.load { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }

    private func makeCake(_ id: Int) -> CakeItem {
        CakeItem(title: "Cake \(id)", desc: "Cake desc \(id)", image: URL(string: "https://cake-url-\(id).com")!)
    }

    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error) {
            messages[0].completion(.failure(error))
        }

        func complete(with items: CakeList) {
            messages[0].completion(.success(items))
        }
    }
}
