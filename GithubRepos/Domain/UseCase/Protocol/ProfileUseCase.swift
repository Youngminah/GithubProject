//
//  ProfileUseCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileUseCase {

    var successReqeustUserInfo: PublishRelay<UserInfo> { get set }
    var successReqeustUserRepos: PublishRelay<[RepoItem]> { get set }
    var successUnstarred: PublishRelay<Void> { get set }
    var failGithubError: PublishRelay<GithubServerError> { get set }

    func requestUserInfo()
    func requestUserStarredRepos(page: Int)
}
