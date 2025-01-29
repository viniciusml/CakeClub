//
//  CakeListTableViewDataSource.swift
//  CakeClub
//
//  Created by Vinicius Leal on 29/01/2025.
//  Copyright © 2025 Vinicius Leal. All rights reserved.
//

import UIKit

final class CakeListTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var tableModel = [CakeImageCellController]()
    
    func reveal(_ list: [CakeImageCellController], in tableView: UITableView) {
        tableModel = list
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath)
            .view()
            .withBackgroundColor(for: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CakeImageCellController {
        tableModel[indexPath.row]
    }
}
