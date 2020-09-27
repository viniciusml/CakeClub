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
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()

    public let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .heavy)
        lb.textColor = .secondaryLabel
        lb.numberOfLines = 0
        return lb
    }()

    public var cakeImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 80.0
        return iv
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        selectionStyle = .none
        backgroundColor = UIColor(red: 248/255, green: 216/255, blue: 158/255, alpha: 1.0)
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
                               leading: nil,
                               bottom: nil,
                               trailing: self.trailingAnchor,
                               padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20),
                               size: CGSize(width: 160, height: 160))


        titleLabel.anchor(top: self.topAnchor,
                          leading: self.leadingAnchor,
                         bottom: nil,
                         trailing: cakeImageView.trailingAnchor,
                         padding: UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 0))

        descriptionLabel.anchor(top: cakeImageView.bottomAnchor,
                                leading: self.leadingAnchor,
                                bottom: self.bottomAnchor,
                                trailing: self.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
    }
}
