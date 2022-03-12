//
//  GithubTabBarViewController.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import UIKit

final class GithubTabBarViewController: UITabBarController {

    private let loginBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github"
        navigationItem.rightBarButtonItem = loginBarButton
        loginBarButton.title = "로그인"
    }
}
