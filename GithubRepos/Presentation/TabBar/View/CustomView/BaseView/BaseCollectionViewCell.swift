//
//  BaseCollectionViewCell.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UICollectionViewCell

class BaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfiguration()
        setView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setView() { }
    func setConstraints() { }
    func setConfiguration() { }
}
