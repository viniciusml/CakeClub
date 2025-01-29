//
//  CakeListViewController.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class CakeListViewController: UIViewController {
    public typealias CallBack = () -> Void
    
    private(set) public lazy var tableView = UITableView()
    private(set) public lazy var headerView: StretchyTableHeaderView = {
        var headerHeight: CGFloat { 180 }
        var headerWidth: CGFloat { self.view.bounds.width }
        let headerView = StretchyTableHeaderView(width: headerWidth, height: headerHeight)
        headerView.titleLabel.text = Constant.Text.listControllerTitle
        return headerView
    }()
    
    private let dataSource = CakeListTableViewDataSource()
    private let delegate = CakeListTableViewDelegate()
    
    var tableModel = [CakeImageCellController]() {
        didSet {
            let dataSource = tableView.dataSource(ofType: CakeListTableViewDataSource.self)
            dataSource?.reveal(tableModel, in: tableView)
        }
    }
    var callBack: CallBack

    public init(callBack: @escaping CallBack) {
        self.callBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        callBack()

        view.addSubview(tableView)
        tableView.fillSuperview()
        configure(tableView)
        bindHeaderView(to: delegate)
    }

    private func configure(_ tableView: UITableView) {
        ComposedCakeListTableViewBuilder(headerView: headerView)
            .withRegisteredCellType(CakeCell.self)
            .withSeparatorStyle(.none)
            .withDataSource(dataSource)
            .withDelegate(delegate)
            .build(with: tableView)
    }
    
    private func bindHeaderView(to delegate: CakeListTableViewDelegate) {
        delegate.onScrollCallBack = { [weak self] contentOffset, contentInset in
            guard let self else { return }
            self.headerView.scrollViewDidScroll(contentOffset: contentOffset, contentInset: contentInset)
        }
    }
}
