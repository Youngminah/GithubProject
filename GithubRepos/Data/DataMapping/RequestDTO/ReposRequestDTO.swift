//
//  ReposRequestDTO.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

struct ReposRequestDTO: Encodable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "q": searchName,
            "page": page
        ]
        return dict
    }

    let searchName: String
    let page: Int

    init(query: ReposQuery, page: Int) {
        self.searchName = query.searchName
        self.page = page
    }
}
