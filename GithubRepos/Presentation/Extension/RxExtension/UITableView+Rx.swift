//
//  UITableView+Rx.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UITableView
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    func isEmpty(title: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setNoDataPlaceholder(title: title)
            } else {
                tableView.removeNoDataPlaceholder()
            }
        }
    }
}
