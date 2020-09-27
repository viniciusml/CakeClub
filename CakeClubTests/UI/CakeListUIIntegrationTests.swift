//
//  CakeListUIIntegrationTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest

class CakeCell: UITableViewCell {
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
}

class CakeViewModel {
    private let cakeLoader: CakeLoader

    var onLoadSuccess: (() -> Void)?
    private(set) var cakeList = CakeList()

    init(cakeLoader: CakeLoader) {
        self.cakeLoader = cakeLoader
    }

    func loadCakes() {
        cakeLoader.load { [weak self] result in
            if let cakeList = try? result.get() {
                self?.cakeList = cakeList
                self?.onLoadSuccess?()
            }
        }
    }
}

class CakeListViewController: UITableViewController {
    private var viewModel: CakeViewModel?
    private var tableModel = CakeList()

    convenience init(viewModel: CakeViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Would you have some cake?"
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.loadCakes()

        viewModel?.onLoadSuccess = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cakeList.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cake = viewModel?.cakeList[indexPath.row]
        let cell = CakeCell()
        cell.nameLabel.text = cake?.title
        cell.descriptionLabel.text = cake?.desc
        return cell
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

    func test_loadCakesCompletion_rendersSuccessfullyLoadedList() {
        let item0 = makeCake(1)

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)

        loader.completeListLoading(with: [item0], at: 0)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)

        let ds = sut.tableView.dataSource
        let index = IndexPath(item: 0, section: 0)
        let view = ds?.tableView(sut.tableView, cellForRowAt: index) as? CakeCell
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.nameLabel.text, item0.title)
        XCTAssertEqual(view?.descriptionLabel.text, item0.desc)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CakeListViewController, loader: RemoteCakeLoaderSpy) {
        let loader = RemoteCakeLoaderSpy()
        let viewModel = CakeViewModel(cakeLoader: loader)
        let sut = CakeListViewController(viewModel: viewModel)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(viewModel)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    class RemoteCakeLoaderSpy: CakeLoader {
        private var completions = [(CakeLoader.Result) -> Void]()

        var loadCallCount: Int {
            completions.count
        }

        func load(completion: @escaping (CakeLoader.Result) -> Void) {
            completions.append(completion)
        }

        func completeListLoading(with list: CakeList = [], at index: Int = 0) {
            completions[index](.success(list))
        }
    }
}
