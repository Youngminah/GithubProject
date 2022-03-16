//
//  AuthViewModel.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import Foundation
import ProgressHUD
import RxCocoa
import RxSwift

final class AuthViewModel: ViewModelType {

    private let useCase: AuthUseCase

    struct Input {
        let requestLogin: Signal<String>
        let logoutBarButtonTap: Signal<Void>
    }
    struct Output {
        let loginAction: Signal<Void>
        let logoutAction: Signal<Void>
    }
    var disposeBag = DisposeBag()

    private let loginAction = PublishRelay<Void>()
    private let logoutAction = PublishRelay<Void>()

    init(useCase: AuthUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.requestLogin
            .emit(onNext: { [weak self] code in
                self?.requestLogin(code: code)
            })
            .disposed(by: disposeBag)

        input.logoutBarButtonTap
            .emit(onNext: { [weak self] in
                self?.requestLogout()
                self?.logoutAction.accept(())
            })
            .disposed(by: disposeBag)

        self.useCase.successLogin
            .asSignal()
            .emit(to: loginAction)
            .disposed(by: disposeBag)

        self.useCase.failGithubError
            .asSignal()
            .emit(onNext: { _ in
                ProgressHUD.show("로그인 실패", icon: .failed, interaction: false)
            })
            .disposed(by: disposeBag)

        return Output(
            loginAction: loginAction.asSignal(),
            logoutAction: logoutAction.asSignal()
        )
    }
}

extension AuthViewModel {

    private func requestLogin(code: String) {
        self.useCase.requestLogin(code: code)
    }

    private func requestLogout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
}
