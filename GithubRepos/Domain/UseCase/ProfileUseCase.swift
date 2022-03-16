//
//  ProfileUseCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation
import RxCocoa
import RxSwift

final class ProfileUseCase {

    private let githubRepository: GithubRepositoryType
    private let disposeBag = DisposeBag()

    let successReqeustUserInfo = PublishRelay<UserInfo>()
    let successReqeustUserRepos = PublishRelay<[RepoItem]>()
    let successUnstarred = PublishRelay<Void>()
    let failGithubError = PublishRelay<GithubServerError>()

    init(
        githubRepository: GithubRepositoryType
    ){
        self.githubRepository = githubRepository
    }
}

extension ProfileUseCase {

    func requestUserInfo() {
        self.githubRepository.requestUserInfo() { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let userInfo):
                UserDefaults.standard.set(userInfo.userId, forKey: "userId")
                self.successReqeustUserInfo.accept(userInfo)
            case .failure(let error):
                self.failGithubError.accept(error)
            }
        }
    }

    func requestUserStarredRepos(page: Int) {
        let owners = UserDefaults.standard.string(forKey: "userId")!
        self.githubRepository.requestUserStarredRepos(owners: owners, page: page) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let userRepos):
                print("응답 받아온 값-->", userRepos[0].fullName)
                self.successReqeustUserRepos.accept(userRepos)
            case .failure(let error):
                self.failGithubError.accept(error)
            }
        }
    }
}
