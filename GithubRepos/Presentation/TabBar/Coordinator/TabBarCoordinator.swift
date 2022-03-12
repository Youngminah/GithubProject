//
//  TabBarCoordinator.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var type: CoordinatorStyleCase = .tab

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
        self.tabBarController = GithubTabBarViewController()
    }

    func start() {
        let pages: [TabBarPageCase] = TabBarPageCase.allCases
        let controllers: [UIViewController] = pages.map {
            self.createTabViewController(of: $0)
        }
        self.configureTabBarController(with: controllers)
    }

    func currentPage() -> TabBarPageCase? {
        TabBarPageCase(index: self.tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPageCase) {
        self.tabBarController.selectedIndex = page.pageOrderNumber
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPageCase(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber
    }

    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPageCase.search.pageOrderNumber
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .gray100
        self.tabBarController.tabBar.tintColor = .gray600
        self.tabBarController.tabBar.unselectedItemTintColor = .gray600
        self.navigationController.pushViewController(tabBarController, animated: true)
    }

    private func configureTabBarItem(of page: TabBarPageCase) -> UITabBarItem {
        return UITabBarItem(
            title: page.pageTitle,
            image: UIImage(systemName: page.tabIconName()),
            tag: page.pageOrderNumber
        )
    }

    private func createTabViewController(of page: TabBarPageCase) -> UIViewController {
        switch page {
        case .search:
            let vc = SearchViewController(
                viewModel: SearchViewModel(
                    coordinator: self,
                    useCase: SearchUseCase(
                        githubRepository: GithubRepository()
                    )
                )
            )
            vc.tabBarItem = self.configureTabBarItem(of: .search)
            vc.tabBarItem.selectedImage = UIImage(systemName: page.tabSelectedIconName())
            return vc
        case .profile:
            let vc = ProfileViewController(
                viewModel: ProfileViewModel(
                    coordinator: self,
                    useCase: ProfileUseCase(
                        githubRepository: GithubRepository()
                    )
                )
            )
            vc.tabBarItem = self.configureTabBarItem(of: .profile)
            vc.tabBarItem.selectedImage = UIImage(systemName: page.tabSelectedIconName())
            return vc
        }
    }
}

extension TabBarCoordinator: CoordinatorDelegate {

    func didFinish(childCoordinator: Coordinator) {
        self.delegate?.didFinish(childCoordinator: self)
    }
}
