//
//  UITableView+Rx.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UITableView
import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {

    func isEmpty(title: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setEmptyBackgroundView(title: title)
            } else {
                tableView.removeBackgroundView()
            }
        }
    }

    func isRefresh() -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setLoadingBackgroundView()
            } else {
                tableView.removeBackgroundView()
            }
        }
    }

    func isAnimatingBottomSpinner() -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.createSpinnerFooter()
            } else {
                tableView.removeSpinnerFooter()
            }
        }
    }

    var didScrollToBottom: Observable<Void> {
        return didScroll.filter {
            let offSetY = base.contentOffset.y
            let contentHeight = base.contentSize.height
            return offSetY > (contentHeight - base.frame.size.height - 100)
        }
    }
}
