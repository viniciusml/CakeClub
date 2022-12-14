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

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.cakeList[indexPath.row]
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
        imageLoader.loadImage(from: item.image, into: cell.cakeImageView)
        return cell
    }
}

extension CakeListViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}
