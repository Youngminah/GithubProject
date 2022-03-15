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
    case userStarredRepos(owners: String, parameters: DictionaryType)
    case user(owners: String)
    // star
    case isStar(repos: String)
    case star(repos: String)
    case unstar(repos: String)
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
        case .userStarredRepos(let owners, _):
            return "/users/\(owners)/starred"
        case .user(let owners):
            return "/users/\(owners)"
        case .isStar(let repos),
             .star(let repos),
             .unstar(let repos):
            return "/user/starred/\(repos)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search,
             .userStarredRepos,
             .user,
             .isStar:
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
             .userStarredRepos(_, let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .user,
             .isStar,
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
             .userStarredRepos,
             .user:
//            return [
//                "Accept": "application/vnd.github.v3+json",
//            ]
            let token = "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"
            return [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "Bearer \(token)"
            ]
        case .isStar,
             .star,
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

extension GithubTarget: MoyaCacheable {

    var cachePolicy: MoyaCacheablePolicy {
        switch self {
        case .userStarredRepos, .isStar, .star, .unstar:
            return .reloadIgnoringLocalAndRemoteCacheData
        default:
            return .useProtocolCachePolicy
        }
    }
}
