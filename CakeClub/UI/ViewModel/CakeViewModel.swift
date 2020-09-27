//
//  CakeViewModel.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

public class CakeViewModel {
    typealias Observer = (() -> Void)
    private let cakeLoader: CakeLoader

    var onLoadSuccess: Observer?
    var onLoadFailure: Observer?
    private(set) var cakeList = CakeList()

    public init(cakeLoader: CakeLoader) {
        self.cakeLoader = cakeLoader
    }

    func loadCakes() {
        cakeLoader.load { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(cakeList):
                self.cakeList = cakeList
                self.onLoadSuccess?()
            case .failure:
                self.onLoadFailure?()
            }
        }
    }
}
