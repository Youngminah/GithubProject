//
//  TabBarPageCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

enum TabBarPageCase: String, CaseIterable {
    case search, profile

    init?(index: Int) {
        switch index {
        case 0: self = .search
        case 1: self = .profile
        default: return nil
        }
    }

    var pageOrderNumber: Int {
        switch self {
        case .search: return 0
        case .profile: return 1
        }
    }

    var pageTitle: String {
        switch self {
        case .search:
            return "검색"
        case .profile:
            return "프로필"
        }
    }

    func tabIconName() -> String {
        switch self {
        case .search:
            return "magnifyingglass.circle"
        case .profile:
            return "person"
        }
    }

    func tabSelectedIconName() -> String {
        switch self {
        case .search:
            return "magnifyingglass.circle.fill"
        case .profile:
            return "person.fill"
        }
    }
}

