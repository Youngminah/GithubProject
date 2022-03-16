//
//  Repos.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

struct Repos: Equatable {

    let items: [RepoItem]
}

struct RepoItem: Equatable, Identifiable {

    let id: Int
    let fullName: String
    let description: String?
    let topics: [String]
    var star: Int
    let fork: Int
    let language: String?
    let updatedAt: Date

    static func == (lhs: RepoItem, rhs: RepoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
