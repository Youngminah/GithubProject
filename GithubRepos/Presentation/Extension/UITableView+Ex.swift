//
//  UITableView+Ex.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UITableView

extension UITableView {

    func setNoDataPlaceholder(title: String) {
        self.backgroundView = EmptyTableBackgroundView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: self.bounds.width,
                          height: self.bounds.height),
            title: title)
        self.isScrollEnabled = false
        self.separatorStyle = .none
    }

    func removeNoDataPlaceholder() {
         self.isScrollEnabled = true
         self.backgroundView = nil
         self.separatorStyle = .singleLine
     }
}
