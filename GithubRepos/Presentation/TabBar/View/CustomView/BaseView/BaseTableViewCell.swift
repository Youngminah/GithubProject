//
//  BaseTableViewCell.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UITableViewCell

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConfiguration()
        setView()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setView() { }
    func setConstraints() { }

    func setConfiguration() {
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
