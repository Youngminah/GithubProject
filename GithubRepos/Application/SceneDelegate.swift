//
//  SceneDelegate.swift
//  GithubRepos
//
//  Created by meng on 2022/03/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let nav = UINavigationController()
        coordinator = AppCoordinator(nav)
        coordinator?.start()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            let components = URLComponents(string: url.absoluteString)
            let items = components?.queryItems ?? []
            for item in items {
                if item.name == "code" {
                    let notification = Notification(name: Notification.Name(rawValue: "DeepLink"), object: item.value)
                    NotificationCenter.default.post(notification)
                }
            }
        }
    }
}

