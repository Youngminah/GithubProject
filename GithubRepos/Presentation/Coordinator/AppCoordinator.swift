//
//  AppCoordinator.swift
//  GithubRepos
//
//  Created by meng on 2022/03/11.
//

import UIKit

final class AppCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .app

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        connectInvestFlow()
    }

    private func connectInvestFlow() {
//        let investCoordinator = InvestCoordinator(self.navigationController)
//        investCoordinator.delegate = self
//        investCoordinator.start()
//        childCoordinators.append(investCoordinator)
    }
}

extension AppCoordinator: CoordinatorDelegate {

    func didFinish(childCoordinator: Coordinator) {
        finish()
    }
}
