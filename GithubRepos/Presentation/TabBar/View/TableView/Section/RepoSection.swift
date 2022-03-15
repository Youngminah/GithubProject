//
//  RepoSection.swift
//  GithubRepos
//
//  Created by meng on 2022/03/14.
//

import RxDataSources

typealias RepoItems = [RepoItem]

struct RepoSection {

    typealias RepoSectionModel = SectionModel<Int, RepoItems>

    enum RepoItems: Equatable {
        case firstItem(RepoItem)
    }
}
