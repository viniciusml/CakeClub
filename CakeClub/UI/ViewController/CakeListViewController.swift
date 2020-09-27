//
//  CakeListViewController.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class CakeListViewController: UITableViewController {
    private var viewModel: CakeViewModel?
    private var imageLoader: CakeImageLoader?
    private var tableModel = CakeList()

    let cellHeight: CGFloat = 260

    public convenience init(viewModel: CakeViewModel, imageLoader: CakeImageLoader) {
        self.init()
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Would you have some cake?"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CakeCell.self)

        bind(tableView, to: viewModel)
    }

    private func bind(_ tableView: UITableView, to viewModel: CakeViewModel?) {
        viewModel?.onLoadSuccess = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel?.loadCakes()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cakeList.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel?.cakeList[indexPath.row]
        guard let cell = dequeueCakeCell(tableView, with: cellModel) else { return UITableViewCell() }
        return cell
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    private func dequeueCakeCell(_ tableView: UITableView, with item: CakeItem?) -> CakeCell? {
        guard let cell = tableView.dequeueReusableCell(CakeCell.self),
              let item = item else { return nil }
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.desc
        imageLoader?.loadImage(from: item.image, into: cell.cakeImageView, completion: nil)
        return cell
    }
}
