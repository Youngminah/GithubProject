//
//  Repos.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

struct Repos {

    let items: [RepoItem]
}

struct RepoItem {

    let id: Int
    let fullName: String
    let description: String?
    let topics: [String]?
    let star: Int
    let fork: Int
    let language: String?
    let updatedAt: Date
}