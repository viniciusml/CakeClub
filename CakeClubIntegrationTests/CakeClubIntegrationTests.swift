//
//  CakeClubIntegrationTests.swift
//  CakeClubIntegrationTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Alamofire
import CakeClub
import XCTest

class AFHTTPClient: HTTPClient {

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: CakeList.self) { response in

                switch response.result {
                case let .success(value):
                    completion(.success(value))
                case let .failure(error):
                    completion(.failure(error))
                }
        }
    }
}

class CakeClubIntegrationTests: XCTestCase {

    func test_endToEndServerGETCakesResult_matchesFixedTestData() {

        switch getCakesResult() {
        case let .success(items)?:
            XCTAssertEqual(items[0], expectedItem(at: 0))
            XCTAssertEqual(items[1], expectedItem(at: 1))

        case let .failure(error)?:
            XCTFail("Expected successful cakes result, got \(error) instead")

        default:
            XCTFail("Expected successful cakes result, got no result instead")
        }
    }

    // MARK: - Helpers

    private func getCakesResult(file: StaticString = #file, line: UInt = #line) -> CakeLoader.Result? {
        let serverURL = URL(string: Constant.endpoint)!
        let client = AFHTTPClient()
        let loader = RemoteCakeLoader(url: serverURL, client: client)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: CakeLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        return receivedResult
    }

    private func expectedItem(at index: Int) -> CakeItem {
        [CakeItem(
            title: "Lemon cheesecake",
            desc: "A cheesecake made of lemon",
            image: URL(string: "https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg")!),
         CakeItem(
            title: "victoria sponge",
            desc: "sponge with jam",
            image: URL(string: "http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg")!)][index]
    }
}
