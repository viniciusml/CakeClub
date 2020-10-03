//
//  CakeListViewController.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class CakeListViewController: UIViewController {
    private(set) public lazy var tableView = binded(UITableView())

    private var viewModel: CakeViewModel?
    private var imageLoader: CakeImageLoader?
    private var tableModel = CakeList()

    private let cellHeight: CGFloat = 260

    public convenience init(viewModel: CakeViewModel, imageLoader: CakeImageLoader) {
        self.init()
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = Constant.Text.listControllerTitle
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
