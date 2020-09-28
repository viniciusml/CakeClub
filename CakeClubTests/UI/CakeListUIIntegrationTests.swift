//
//  CakeListUIIntegrationTests.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import XCTest
import ViewControllerPresentationSpy

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

    func test_loadCakesCompletion_rendersSuccessfullyLoadedAndFormattedList() {
        var itemList = [CakeItem]()
        for n in 0...10 {
            itemList.append(makeCake(n))
        }

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeListLoading(with: itemList)
        assertThat(sut, isRendering: itemList.capitalized())
    }

    func test_cakeImageView_loadsImageURLWhenVisible() {
        let item0 = makeCake(0)
        let item1 = makeCake(1)

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [item0, item1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateCakeViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [cakeImageURL(0)], "Expected first image URL request once first view becomes visible")

        sut.simulateCakeViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [cakeImageURL(0), cakeImageURL(1)], "Expected second image URL request once second view also becomes visible")
    }

    func test_loadCakesFailure_displaysErrorAlert() {
        let (sut, loader) = makeSUT()
        let alertVerifier = AlertVerifier()

        sut.loadViewIfNeeded()
        loader.completeListLoading(with: .HTTPClientError)

        alertVerifier.verify(
            title: "Alert",
            message: "Something went wrong. Please try again.",
            animated: true,
            actions: [
                .default("OK")],
            presentingViewController: sut
        )
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CakeListViewController, loader: RemoteCakeLoaderSpy) {
        let loader = RemoteCakeLoaderSpy()
        let sut = CakeListUIComposer.cakeListComposedWith(countryLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func assertThat(_ sut: CakeListViewController, isRendering list: CakeList, file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedCakeItems() == list.count else {
            return XCTFail("Expected \(list.count) items, got \(sut.numberOfRenderedCakeItems()) instead", file: file, line: line)
        }

        list.enumerated().forEach { index, item in
            assertThat(sut, hasViewConfiguredFor: item, at: index, file: file, line: line)
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

    private func cakeImageURL(_ id: Int) -> URL {
        URL(string: "https://cake-url-\(id).com")!
    }

    private func makeImageData() -> Data {
        UIImage.make(withColor: .red).pngData()!
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

        func completeListLoading(with error: LoadingError) {
            completions[0](.failure(error))
        }

        // MARK: - Cake Image Loader

        var loadedImageURLs = [URL]()

        func loadImage(from url: URL, into view: UIImageView) {
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

    @discardableResult
    func simulateCakeViewVisible(at index: Int) -> CakeCell? {
        cakeItem(at: index) as? CakeCell
    }
}

private extension CakeCell {
    var cakeTitle: String? {
        titleLabel.text
    }

    var cakeDescription: String? {
        descriptionLabel.text
    }

    var imageData: Data? {
        cakeImageView.image?.pngData()
    }
}

private extension Array where Element == CakeItem {
    func capitalized() -> CakeList {
        self.map { CakeItem(title: $0.title.capitalized, desc: $0.desc.capitalized, image: $0.image) }
    }
}
