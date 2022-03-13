//
//  DynamicCollectionView.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UICollectionView

final class DynamicCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}
