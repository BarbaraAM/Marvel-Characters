//
//  SceneDelegate.swift
//  Marvel Characters
//
//  Created by Barbara Argolo on 25/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
    
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let navigationController = UINavigationController()
        self.coordinator = AppCoordinator(navigationController)
        self.coordinator?.start()
        
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
}

