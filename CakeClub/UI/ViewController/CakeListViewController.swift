//
//  CakeListViewController.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class StretchyTableHeaderView: UIView {
    public let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 30, weight: .black)
        lb.textColor = .label
        return lb
    }()
}

public class CakeListViewController: UIViewController {
    private var cellHeight: CGFloat { 260 }
    private var headerHeight: CGFloat { 260 }
    private var headerWidth: CGFloat { self.view.bounds.width }

    private(set) public lazy var tableView = binded(UITableView())
    private(set) public lazy var headerView: StretchyTableHeaderView = {
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight))
        headerView.titleLabel.text = Constant.Text.listControllerTitle
        return headerView
    }()

    private var viewModel: CakeViewModel?
    private var imageLoader: CakeImageLoader?
    private var tableModel = CakeList()

    public convenience init(viewModel: CakeViewModel, imageLoader: CakeImageLoader) {
        self.init()
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.loadCakes()

        view.addSubview(tableView)
    }

    private func binded(_ tableView: UITableView) -> UITableView {
        configure(tableView)
        viewModel?.onLoadSuccess = strongify(weak: tableView) { strongTableView in
            strongTableView.reloadData()
        }

        viewModel?.onLoadFailure = strongify(weak: self) { strongSelf in
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
        viewModel?.cakeList.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cakeList[indexPath.row]
        guard let cell = configureCakeCell(tableView, with: cellModel) else { return UITableViewCell() }
        cell.setBackgroundColor(for: indexPath)
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.fadeIn(at: indexPath)
    }

    private func configureCakeCell(_ tableView: UITableView, with item: CakeItem?) -> CakeCell? {
        guard let cell = tableView.dequeueReusableCell(CakeCell.self),
              let item = item else { return nil }
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.desc
        imageLoader?.loadImage(from: item.image, into: cell.cakeImageView)
        return cell
    }
}
