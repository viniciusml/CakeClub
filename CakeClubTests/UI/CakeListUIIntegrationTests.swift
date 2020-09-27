//
//  CakeListUIIntegrationTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest

class CakeViewModel {
    private let cakeLoader: CakeLoader

    init(cakeLoader: CakeLoader) {
        self.cakeLoader = cakeLoader
    }

    func loadCakes() {
        cakeLoader.load { _ in }
    }
}

class CakeListViewController: UIViewController {

    private var viewModel: CakeViewModel?

    convenience init(viewModel: CakeViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Would you have some cake?"
        viewModel?.loadCakes()
    }
}

class CakeListUIIntegrationTests: XCTestCase {

    func test_viewDidLoad_showsCorrectTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, "Would you have some cake?")
    }

    func test_init_doesNotMakeRequest() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_requestsCakesLoading() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line)  -> (sut: CakeListViewController, loader: RemoteCakeLoaderSpy) {
        let loader = RemoteCakeLoaderSpy()
        let viewModel = CakeViewModel(cakeLoader: loader)
        let sut = CakeListViewController(viewModel: viewModel)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(viewModel)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    class RemoteCakeLoaderSpy: CakeLoader {

        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (CakeLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
