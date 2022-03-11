//
//  Coordinator.swift
//  GithubRepos
//
//  Created by meng on 2022/03/11.
//

import UIKit

enum CoordinatorStyleCase {
    case app, invest
}

protocol Coordinator: AnyObject {

    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorStyleCase { get }

    func start()
    func finish()

    init(_ navigationController: UINavigationController)
}

extension Coordinator {

    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
}
