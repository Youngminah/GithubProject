//
//  BaseViewController.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        setConstraints()
    }

    func setViews() { }
    func setConstraints() { }

    func setConfigurations() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
    }
}
