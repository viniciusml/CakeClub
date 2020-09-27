//
//  CakeViewModel.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

public class CakeViewModel {
    private let cakeLoader: CakeLoader

    var onLoadSuccess: (() -> Void)?
    private(set) var cakeList = CakeList()

    public init(cakeLoader: CakeLoader) {
        self.cakeLoader = cakeLoader
    }

    func loadCakes() {
        cakeLoader.load { [weak self] result in
            if let cakeList = try? result.get() {
                self?.cakeList = cakeList
                self?.onLoadSuccess?()
            }
        }
    }
}
