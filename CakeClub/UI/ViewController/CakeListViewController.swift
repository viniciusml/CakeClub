//
//  CakeListViewController.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class CakeListViewController: UIViewController {
    private var cellHeight: CGFloat { 260 }
    private var headerHeight: CGFloat { 180 }
    private var headerWidth: CGFloat { self.view.bounds.width }

    private(set) public lazy var tableView = binded(UITableView())
    private(set) public lazy var headerView: StretchyTableHeaderView = {
        let headerView = StretchyTableHeaderView(width: headerWidth, height: headerHeight)
        headerView.titleLabel.text = Constant.Text.listControllerTitle
        return headerView
    }()

    private let viewModel: CakeViewModel
    private let imageLoader: CakeImageLoader
    private var cellControllers = [IndexPath: CakeImageCellController]()

    public init(viewModel: CakeViewModel, imageLoader: CakeImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadCakes()

        view.addSubview(tableView)
        tableView.fillSuperview()
    }

    private func binded(_ tableView: UITableView) -> UITableView {
        configure(tableView)
        viewModel.onLoadSuccess = strongify(weak: tableView) { strongTableView in
            strongTableView.reloadData()
        }

        viewModel.onLoadFailure = strongify(weak: self) { strongSelf in
            guaranteeMainThread {
                strongSelf.showBasicAlert(title: Constant.Text.alertTitle, message: Constant.Text.alertMessage)
            }
        }
        return tableView
    }

    private func configure(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CakeCell.self)
        tableView.tableHeaderView = headerView
    }
}

extension CakeListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cakeList.count
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.fadeIn(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CakeImageCellController {
        let cellModel = viewModel.cakeList[indexPath.row]
        let cellController = CakeImageCellController(model: cellModel, imageLoader: imageLoader)
        cellControllers[indexPath] = cellController
        return cellController
    }
}

extension CakeListViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}
