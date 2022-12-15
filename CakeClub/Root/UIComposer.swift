//
//  UIComposer.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

public enum CakeListUIComposer {

    static func composeCakeListControllerWith(loaderURL url: URL) -> CakeListViewController {
        let client = AFHTTPClient()
        let cakeLoader = RemoteCakeLoader(url: url, client: client)
        let imageLoader = RemoteCakeImageLoader()
        return cakeListComposedWith(countryLoader: cakeLoader, imageLoader: imageLoader)
    }

    public static func cakeListComposedWith(countryLoader: CakeLoader, imageLoader: CakeImageLoader) -> CakeListViewController {
        let cakeViewModel = CakeViewModel(cakeLoader: countryLoader)
        let cakeViewController = CakeListViewController(callBack: cakeViewModel.loadCakes)
        cakeViewModel.onLoadSuccess = adaptCakeListToCellControllers(forwardingTo: cakeViewController, loader: imageLoader)
        cakeViewModel.onLoadFailure = displayFailureMessage(on: cakeViewController)
        return cakeViewController
    }
    
    private static func adaptCakeListToCellControllers(forwardingTo controller: CakeListViewController, loader: CakeImageLoader) -> (CakeList) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                CakeImageCellController(model: model, imageLoader: loader)
            }
        }
    }
    
    private static func displayFailureMessage(on controller: CakeListViewController) -> (Any) -> Void {
        return { [weak controller] _ in
            controller?.showBasicAlert(title: Constant.Text.alertTitle, message: Constant.Text.alertMessage)
        }
    }
}
