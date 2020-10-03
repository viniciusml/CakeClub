//
//  SceneDelegate.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let endpointURL = URL(safeString: Constant.endpoint)
        let cakeListController = CakeListUIComposer.composeCakeListControllerWith(loaderURL: endpointURL)

        window?.rootViewController = cakeListController
        window?.makeKeyAndVisible()
    }
}
