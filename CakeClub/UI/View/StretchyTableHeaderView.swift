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
        lb.font = .systemFont(ofSize: 40, weight: .medium)
        lb.textColor = .label
        lb.numberOfLines = 0
        return lb
    }()

    private var containerViewHeight = NSLayoutConstraint()
    private var titleLabelHeight = NSLayoutConstraint()
    private var titleLabelBottom = NSLayoutConstraint()

    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        setupView()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        titleLabelBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        titleLabelHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}

extension StretchyTableHeaderView: CodeView {
    func buildViewHierarchy() {
        addSubview(containerView)
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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabelBottom = titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        titleLabelBottom.isActive = true
        titleLabelHeight = titleLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        titleLabelHeight.isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    }
}
