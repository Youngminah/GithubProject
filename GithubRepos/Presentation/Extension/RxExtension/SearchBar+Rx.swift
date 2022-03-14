//
//  SearchBar+Rx.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UISearchBar
import RxCocoa
import RxSwift

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
