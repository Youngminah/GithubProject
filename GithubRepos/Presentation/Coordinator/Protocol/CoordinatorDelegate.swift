//
//  CoordinatorDelegate.swift
//  GithubRepos
//
//  Created by meng on 2022/03/11.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {

    func didFinish(childCoordinator: Coordinator)
}
