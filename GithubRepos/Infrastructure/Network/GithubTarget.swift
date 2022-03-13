//
//  GithubTarget.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation
import Moya

typealias DictionaryType = [String: Any]

enum GithubTarget {
    // search
    case search(parameters: DictionaryType)
    // users
    case userRepos(owners: String, parameters: DictionaryType)
    case user(owners: String)
    // star
    case star(owners: String, repos: String)
    case unstar(owners: String, repos: String)
}

extension GithubTarget: TargetType {

    var baseURL: URL {
        guard let url = URL(string: APIConstant.environment.rawValue) else {
            fatalError("fatal error - invalid api url")
        }
        return url
    }

    var path: String {
        switch self {
        case .search:
            return "/search/repositories"
        case .userRepos(let owners, _):
            return "/users/\(owners)/repos"
        case .user(let owners):
            return "/users/\(owners)"
        case .star(let owners, let repos),
             .unstar(let owners, let repos):
            return "/user/starred/\(owners)/\(repos)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search,
             .userRepos,
             .user:
            return .get
        case .star:
            return .put
        case .unstar:
            return .delete
        }
    }

    var sampleData: Data {
        return stubData(self)
    }

    var task: Task {
        switch self {
        case .search(let parameters),
             .userRepos(_, let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .user,
             .star,
             .unstar:
            return .requestPlain
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var headers: [String: String]? {
        switch self {
        case .search,
             .userRepos,
             .user:
            return [
                "Accept": "application/vnd.github.v3+json",
            ]
        case .star,
             .unstar:
            //let token = UserDefaults.standard.string(forKey: "token")!
            let token = "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"
            return [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
}
