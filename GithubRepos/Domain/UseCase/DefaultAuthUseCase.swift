//
//  AuthUseCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import Foundation
import RxCocoa
import RxSwift

final class DefaultAuthUseCase: AuthUseCase {

    private let authRepository: AuthRepositoryType
    private let disposeBag = DisposeBag()

    var successLogin = PublishRelay<Void>()
    var failGithubError = PublishRelay<GithubServerError>()

    init(
        authRepository: AuthRepositoryType
    ){
        self.authRepository = authRepository
    }
}

extension DefaultAuthUseCase {

    func requestLogin(code: String) {
        let clientID = "23a655cd597603f9f109" // 임시
        let clientSecret = "1dc45efc562ec73389d794310f17e1e5a74c0d50" // 임시
        self.authRepository.requestToken(
            clientID: clientID,
            clientSecret: clientSecret,
            code: code) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let info):
                    print("로그인 성공!! -->", info)
                    UserDefaults.standard.set(info.accessToken, forKey: "accessToken")
                    self.successLogin.accept(())
                case .failure(let error):
                    print("로그인 실패!! -->", error)
                    self.failGithubError.accept(error)
                }
            }
    }
}
