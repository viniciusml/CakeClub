//
//  CakeListViewController+TestHelpers.swift
//  CakeClubTests
//
//  Created by Vinicius Leal on 03/10/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import CakeClub
import UIKit

extension CakeListViewController {
    var sceneTitle: String? {
        (tableView.tableHeaderView as! StretchyTableHeaderView).titleLabel.text
    }

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
