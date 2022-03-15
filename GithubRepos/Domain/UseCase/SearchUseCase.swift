//
//  SearchUseCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchUseCase {

    private let githubRepository: GithubRepositoryType
    private let disposeBag = DisposeBag()

    let successReqeustSearch = PublishRelay<Repos>()
    let successReqeustStar = PublishRelay<Void>()
    let successReqeustUnstar = PublishRelay<Void>()
    let failGithubError = PublishRelay<GithubServerError>()

    init(
        githubRepository: GithubRepositoryType
    ){
        self.githubRepository = githubRepository
    }
}

extension SearchUseCase {

    func requestSearch(searchName: String, page: Int) {
        let query = ReposQuery(searchName: searchName)
        self.githubRepository.requestSearch(query: query, page: page) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let repos):
                self.successReqeustSearch.accept(repos)
            case .failure(let error):
                self.failGithubError.accept(error)
            }
        }
    }
}
