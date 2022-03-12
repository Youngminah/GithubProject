//
//  UserReposRequestDTO.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

struct UserReposRequestDTO: Encodable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "page": page
        ]
        return dict
    }

    let page: Int
}
