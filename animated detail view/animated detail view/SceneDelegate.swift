//
//  SceneDelegate.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let mainView = ViewControllerBuilder
            .build(concreteDecorator: ViewControllerDecorator())
        window?.rootViewController = UINavigationController(rootViewController: mainView)
        window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
