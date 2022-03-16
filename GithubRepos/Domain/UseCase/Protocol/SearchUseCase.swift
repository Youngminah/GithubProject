//
//  SearchUseCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchUseCase {

    var successReqeustSearch: PublishRelay<Repos> { get set }
    var failGithubError: PublishRelay<GithubServerError> { get set }

    func requestSearch(searchName: String, page: Int)
}
