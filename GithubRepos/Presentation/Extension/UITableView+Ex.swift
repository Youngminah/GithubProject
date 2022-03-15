//
//  UITableView+Ex.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UITableView

extension UITableView {

    func setEmptyBackgroundView(title: String, imageName: String) {
        self.backgroundView = EmptyBackgroundView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: self.bounds.width,
                          height: self.bounds.height),
            title: title,
        imageName: imageName)
        self.isScrollEnabled = false
        self.separatorStyle = .none
    }

    func setLoadingBackgroundView() {
        self.backgroundView = LoadingBackgroundView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: self.bounds.width,
                          height: self.bounds.height)
        )
        self.isScrollEnabled = false
        self.separatorStyle = .none
    }

    func removeBackgroundView() {
         self.isScrollEnabled = true
         self.backgroundView = nil
         self.separatorStyle = .singleLine
     }

    func createSpinnerFooter() {
        let footerView = UIView(
            frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        self.tableFooterView = footerView
    }

    func removeSpinnerFooter() {
        self.tableFooterView = nil
    }
}
