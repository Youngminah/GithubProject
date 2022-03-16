//
//  AuthTarget.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation
import Moya


enum AuthTarget {

    case login(parameters: DictionaryType)
}

extension AuthTarget: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://github.com/login/oauth") else {
            fatalError("fatal error - invalid api url")
        }
        return url
    }

    var path: String {
        switch self {
        case .login:
            return "/access_token"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .login(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var headers: [String: String]? {
        switch self {
        case .login:
            return [
                "Accept": "application/vnd.github.v3+json",
            ]
        }
    }
}
