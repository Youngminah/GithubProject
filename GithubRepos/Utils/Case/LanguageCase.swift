//
//  LanguageCase.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit

enum LanguageCase: String, CaseIterable {

    case swift = "Swift"
    case ruby = "Ruby"
    case css = "CSS"
    case c = "C"
    case python = "Python"
    case empty = "Empty"
    case unknown

    var color: UIColor {
        switch self {
        case .swift:
            return .orange
        case .ruby:
            return .red
        case .css:
            return .green
        case .c:
            return .yellow200
        case .python:
            return .purple
        case .empty:
            return .secondarySystemGroupedBackground
        case .unknown:
            return .gray500
        }
    }
}
