//
//  GithubTabBarViewController.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol AuthDelegate: AnyObject {

    func login()
    func logout()
}

final class GithubTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    weak var authDelegate: AuthDelegate?

    private let loginBarButton = UIBarButtonItem()
    private let logoutBarButton = UIBarButtonItem()

    private lazy var input = AuthViewModel.Input(
        requestLogin: requestLogin.asSignal(),
        logoutBarButtonTap: logoutBarButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private var viewModel: AuthViewModel
    private let disposeBag = DisposeBag()

    private let requestLogin = PublishRelay<String>()

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("InvestViewController fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeepLink), name: Notification.Name(rawValue: "DeepLink"), object: nil)
        setConfigurations()
        bind()
    }

    @objc private func handleDeepLink(notification: Notification) {
        guard let code = notification.object as? String else {
            return
        }
        print("키득키득-->", code)
        self.requestLogin.accept(code)
    }

    private func bind() {
        self.loginBarButton.rx.tap.asSignal()
            .emit(onNext: { [weak self] _ in
                self?.requestCode()
            })
            .disposed(by: disposeBag)

        output.loginAction
            .emit(onNext: { [weak self] _ in
                self?.setLogoutBarButton()
                self?.authDelegate?.login()
            })
            .disposed(by: disposeBag)

        output.logoutAction
            .emit(onNext: { [weak self] _ in
                self?.setLoginBarButton()
                self?.authDelegate?.logout()
            })
            .disposed(by: disposeBag)
    }

    private func setConfigurations() {
        title = "Github"
        loginBarButton.title = "로그인"
        logoutBarButton.title = "로그아웃"

        if UserDefaults.standard.string(forKey: "accessToken") != nil {
            setLogoutBarButton()
        } else {
            setLoginBarButton()
        }
    }

    private func setLoginBarButton() {
        navigationItem.rightBarButtonItem = loginBarButton
    }

    private func setLogoutBarButton() {
        navigationItem.rightBarButtonItem = logoutBarButton
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let vc = self.selectedViewController as? AuthDelegate else {
            return
        }
        self.authDelegate = vc
    }
}

extension GithubTabBarViewController {

    func requestCode() {
        let clientID = "23a655cd597603f9f109"
        let scope = "repo,user"
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
