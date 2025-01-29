//
//  CakeListTableViewDelegate.swift
//  CakeClub
//
//  Created by Vinicius Leal on 29/01/2025.
//  Copyright © 2025 Vinicius Leal. All rights reserved.
//

import UIKit

final class CakeListTableViewDelegate: NSObject, UITableViewDelegate {
    typealias ScrollCallBack = (_ contentOffset: CGPoint, _ contentInset: UIEdgeInsets) -> Void
    
    private var cellHeight: CGFloat { 260 }
    
    var onScrollCallBack: ScrollCallBack?
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.fadeIn(at: indexPath)
    }
}

extension CakeListTableViewDelegate: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollCallBack?(scrollView.contentOffset, scrollView.contentInset)
    }
}
