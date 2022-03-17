//
//  MockSearchUseCase.swift
//  GithubReposTests
//
//  Created by meng on 2022/03/17.
//

import Foundation

import RxCocoa
import RxSwift
@testable import GithubRepos

final class MockSearchUseCase: SearchUseCase {

    var successReqeustSearch = PublishRelay<Repos>()
    var failGithubError = PublishRelay<GithubServerError>()

    init() { }

    func requestSearch(searchName: String, page: Int) {
        if page < 30 && page > 0 {
            self.successReqeustSearch.accept(
                Repos(
                    items: [
                        RepoItem(id: 1, fullName: "29cmGodRepos/kingkinggod", description: nil, topics: ["29likes", "29king", "29godofkingking"], star: 1000, fork: 2, language: "Swift", updatedAt: Date())
                    ]
                )
            )
        } else {
            self.failGithubError.accept(.unknown)
        }
    }
}
