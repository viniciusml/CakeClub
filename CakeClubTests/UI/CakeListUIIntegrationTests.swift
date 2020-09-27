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
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let cakeImageView = UIImageView()
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
    private var imageLoader: CakeImageLoader?
    private var tableModel = CakeList()

    convenience init(viewModel: CakeViewModel, imageLoader: CakeImageLoader) {
        self.init()
        self.viewModel = viewModel
        self.imageLoader = imageLoader
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
        cell.titleLabel.text = cake?.title
        cell.descriptionLabel.text = cake?.desc
        if let url = cake?.image {
            imageLoader?.loadImage(from: url, into: cell.cakeImageView, completion: nil)
        }
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
        var itemList = [CakeItem]()
        for n in 0...10 {
            itemList.append(makeCake(n))
        }

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeListLoading(with: itemList)
        assertThat(sut, isRendering: itemList)
    }

    func test_cakeImageView_loadsImageURLWhenVisible() {
        let item0 = makeCake(0)
        let item1 = makeCake(1)

        let expectedURL0 = URL(string: "https://cake-url-0.com")!
        let expectedURL1 = URL(string: "https://cake-url-1.com")!

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [item0, item1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateCakeViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [expectedURL0], "Expected first image URL request once first view becomes visible")

        sut.simulateCakeViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [expectedURL0, expectedURL1], "Expected second image URL request once second view also becomes visible")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CakeListViewController, loader: RemoteCakeLoaderSpy) {
        let loader = RemoteCakeLoaderSpy()
        let viewModel = CakeViewModel(cakeLoader: loader)
        let sut = CakeListViewController(viewModel: viewModel, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(viewModel)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func assertThat(_ sut: CakeListViewController, isRendering list: CakeList, file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedCakeItems() == list.count else {
            return XCTFail("Expected \(list.count) items, got \(sut.numberOfRenderedCakeItems()) instead", file: file, line: line)
        }

        list.enumerated().forEach { index, item in
            assertThat(sut, hasViewConfiguredFor: item, at: index)
        }
    }

    private func assertThat(_ sut: CakeListViewController, hasViewConfiguredFor item: CakeItem, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.cakeItem(at: index)

        guard let cell = view as? CakeCell else {
            return XCTFail("Expected \(CakeCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.cakeTitle, item.title, "Expected title text to be \(String(describing: item.title)) for label at index \(index)", file: file, line: line)
        XCTAssertEqual(cell.cakeDescription, item.desc, "Expected description text to be \(String(describing: item.desc)) for label at index \(index)", file: file, line: line)
    }

    class RemoteCakeLoaderSpy: CakeLoader, CakeImageLoader {

        // MARK: - Cake List Loader

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

        // MARK: - Cake Image Loader

        var loadedImageURLs = [URL]()

        func loadImage(from url: URL, into view: UIImageView = UIImageView(), completion: CakeImageLoader.CompletionHandler) {
            loadedImageURLs.append(url)
        }
    }
}

private extension CakeListViewController {
    func numberOfRenderedCakeItems() -> Int {
        tableView.numberOfRows(inSection: cakeItemsSection)
    }

    private var cakeItemsSection: Int { 0 }

    func cakeItem(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(item: row, section: cakeItemsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func simulateCakeViewVisible(at index: Int) {
        _ = cakeItem(at: index)
    }
}

private extension CakeCell {
    var cakeTitle: String? {
        titleLabel.text
    }

    var cakeDescription: String? {
        descriptionLabel.text
    }
}
