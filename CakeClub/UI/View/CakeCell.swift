//
//  CakeCell.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class CakeCell: UITableViewCell {
    public let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()

    public let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 22, weight: .black)
        lb.textColor = .white
        lb.numberOfLines = 2
        return lb
    }()

    public let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .heavy)
        lb.textColor = .tertiaryLabel
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

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        cakeImageView.image = nil
    }

    private func setupViews() {
        buildViewHierarchy()
        setupConstraints()
    }

    private func buildViewHierarchy() {
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(cakeImageView)
        cellBackgroundView.addSubview(titleLabel)
        cellBackgroundView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        cellBackgroundView.anchor(top: topAnchor,
                                  leading: leadingAnchor,
                                  bottom: bottomAnchor,
                                  trailing: trailingAnchor,
                                  padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))

        cakeImageView.anchor(top: cellBackgroundView.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: cellBackgroundView.trailingAnchor,
                             padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20),
                             size: CGSize(width: 160, height: 160))

        titleLabel.anchor(top: cellBackgroundView.topAnchor,
                          leading: cellBackgroundView.leadingAnchor,
                          bottom: nil,
                          trailing: cakeImageView.leadingAnchor,
                          padding: UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 10))

        descriptionLabel.anchor(top: cakeImageView.bottomAnchor,
                                leading: cellBackgroundView.leadingAnchor,
                                bottom: cellBackgroundView.bottomAnchor,
                                trailing: cellBackgroundView.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
    }

    public func setBackgroundColor(for index: IndexPath) {
        let row = index.row
        let color: UIColor

        if row.isMultiple(of: 2) {
            color = Constant.Color.blue
        } else if row.isMultiple(of: 3) {
            color = Constant.Color.yellow
        } else {
            color = Constant.Color.pink
        }
        cellBackgroundView.backgroundColor = color
    }
}
