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
        cakeLoader.load(completion: strongify(weak: self, closure: { strongSelf, result in
            switch result {
            case let .success(cakeList):
                strongSelf.cakeList = cakeList.capitalized()
                strongSelf.onLoadSuccess?()
            case .failure:
                strongSelf.onLoadFailure?()
            }
        }))
    }
}

private extension Array where Element == CakeItem {
    func capitalized() -> CakeList {
        self.map { CakeItem(title: $0.title.capitalized, desc: $0.desc.capitalized, image: $0.image) }
    }
}
