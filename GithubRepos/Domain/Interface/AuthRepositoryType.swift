//
//  AuthRepositoryType.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation

protocol AuthRepositoryType: AnyObject {

    func requestToken(                  // 토큰 요청 API
        clientID: String,
        clientSecret: String,
        code: String,
        completion: @escaping (
            Result< LoginInfo,
            GithubServerError>
        ) -> Void
    )
}
