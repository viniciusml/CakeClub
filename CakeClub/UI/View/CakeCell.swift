//
//  CakeCell.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class CakeCell: UITableViewCell {
    public let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        return lb
    }()

    public let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14)
        lb.numberOfLines = 3
        return lb
    }()

    public var cakeImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        buildViewHierarchy()
        setupConstraints()
    }

    private func buildViewHierarchy() {
        addSubview(cakeImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        cakeImageView.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0),
                               size: CGSize(width: 80, height: 80))


        titleLabel.anchor(top: self.topAnchor,
                         leading: cakeImageView.trailingAnchor,
                         bottom: nil, trailing: nil,
                         padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0))

        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                leading: cakeImageView.trailingAnchor,
                                bottom: self.bottomAnchor,
                                trailing: self.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 20))
    }
}
