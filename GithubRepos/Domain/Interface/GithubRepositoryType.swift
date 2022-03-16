//
//  GithubRepositoryType.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

protocol GithubRepositoryType: AnyObject {

    func requestSearch(                // 레파지토리 검색 API
        query: ReposQuery,
        page: Int,
        completion: @escaping (
            Result< Repos,
            GithubServerError>
        ) -> Void
    )

    func requestUserStarredRepos(     // 유저 레파지토리 조회 API
        owners: String,
        page: Int,
        completion: @escaping (
            Result< [RepoItem],
            GithubServerError>
        ) -> Void
    )

    func requestUserInfo(             // 유저 정보 조회 API
        completion: @escaping (
            Result< UserInfo,
            GithubServerError>
        ) -> Void
    )

    func requestIsStar(               // 레파지토리 좋아요 여부 API
        repos: String,
        completion: @escaping (
            Result< Int,
            GithubServerError>
        ) -> Void
    )

    func requestStar(                 // 레파지토리 좋아요 API
        repos: String,
        completion: @escaping (
            Result< Int,
            GithubServerError>
        ) -> Void
    )

    func requestUnstar(               // 레파지토리 좋아요 취소 API
        repos: String,
        completion: @escaping (
            Result< Int,
            GithubServerError>
        ) -> Void
    )
}
