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
        viewModel?.loadCakes()

        viewModel?.onLoadSuccess = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cakeList.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cake = viewModel?.cakeList[indexPath.row]
        let cell = CakeCell()
        cell.titleLabel.text = cake?.title
        cell.descriptionLabel.text = cake?.desc
        if let url = cake?.image {
            imageLoader?.loadImage(from: url, into: cell.cakeImageView, completion: nil)
        }
        return cell
    }
}
