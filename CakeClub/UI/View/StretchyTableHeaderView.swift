//
//  StretchyTableHeaderView.swift
//  CakeClub
//
//  Created by Vinicius Leal on 03/10/2020.
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

    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }
}

extension StretchyTableHeaderView: CodeView {
    func buildViewHierarchy() {

    }

    func setupConstraints() {

    }
}
