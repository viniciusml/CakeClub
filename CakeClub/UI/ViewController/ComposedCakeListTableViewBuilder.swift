//
//  ComposedCakeListTableViewBuilder.swift
//  CakeClub
//
//  Created by Vinicius Leal on 29/01/2025.
//  Copyright © 2025 Vinicius Leal. All rights reserved.
//

import UIKit

final class ComposedCakeListTableViewBuilder {
    private let headerView: StretchyTableHeaderView
    private var cellType: UITableViewCell.Type?
    private var separatorStyle: UITableViewCell.SeparatorStyle?
    private var dataSource: UITableViewDataSource?
    private var delegate: UITableViewDelegate?
    
    init(headerView: StretchyTableHeaderView) {
        self.headerView = headerView
    }
    
    func withSeparatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = separatorStyle
        return self
    }
    
    func withDataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    func withDelegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    func withRegisteredCellType(_ type: UITableViewCell.Type) -> Self {
        self.cellType = type
        return self
    }
    
    func build(with tableView: UITableView) {
        guard let separatorStyle, let dataSource, let cellType, let delegate else {
            assertionFailure("Required properties need to be set for CakeListTableView set up")
            return
        }
        
        tableView.register(cellType)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.separatorStyle = separatorStyle
        tableView.tableHeaderView = headerView
    }
}
