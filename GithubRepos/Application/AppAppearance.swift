//
//  AppAppearance.swift
//  GithubRepos
//
//  Created by meng on 2022/03/11.
//

import UIKit

final class AppAppearance {

    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        let backImage = UIImage(named: "ico24Back")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().barTintColor = .label
    }
}

