//
//  AuthUseCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation
import RxCocoa
import RxSwift

protocol AuthUseCase {

    var successLogin: PublishRelay<Void> { get set }
    var failGithubError: PublishRelay<GithubServerError> { get set }

    func requestLogin(code: String)
}
