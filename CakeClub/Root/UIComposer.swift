//
//  UIComposer.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public final class CakeListUIComposer {
    private init() {}

    static func composeCakeListControllerWith(loaderURL url: URL) -> CakeListViewController {
        let client = AFHTTPClient()
        let cakeLoader = RemoteCakeLoader(url: url, client: client)
        let imageLoader = RemoteCakeImageLoader()
        return cakeListComposedWith(countryLoader: cakeLoader, imageLoader: imageLoader)
    }

    public static func cakeListComposedWith(countryLoader: CakeLoader, imageLoader: CakeImageLoader) -> CakeListViewController {
        let cakeViewModel = CakeViewModel(cakeLoader: countryLoader)
        let cakeViewController = CakeListViewController(viewModel: cakeViewModel, imageLoader: imageLoader)
        return cakeViewController
    }
}
