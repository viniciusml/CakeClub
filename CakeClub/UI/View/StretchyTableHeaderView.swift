//
//  StretchyTableHeaderView.swift
//  CakeClub
//
//  Created by Vinicius Leal on 03/10/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public class StretchyTableHeaderView: UIView {
    public let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()

    public let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .medium)
        lb.textColor = .label
        lb.textAlignment = .center
        lb.numberOfLines = 1
        return lb
    }()

    public let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cake-header")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10.0
        iv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return iv
    }()

    private(set) public var containerViewHeight = NSLayoutConstraint()
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()

    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        setupView()
    }

    func scrollViewDidScroll(contentOffset: CGPoint, contentInset: UIEdgeInsets) {
        containerViewHeight.constant = contentInset.top
        let offsetY = -(contentOffset.y + contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + contentInset.top, contentInset.top)
    }
}

extension StretchyTableHeaderView: CodeView {
    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])

        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: heightAnchor)
        containerViewHeight.isActive = true

        titleLabel.anchor(top: containerView.topAnchor,
                          leading: self.leadingAnchor,
                          bottom: nil,
                          trailing: self.trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                          size: CGSize(width: 0, height: 60))


        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}
