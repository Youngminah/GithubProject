//
//  StarButton.swift
//  GithubRepos
//
//  Created by meng on 2022/03/15.
//

import UIKit
import SnapKit

final class StarButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConfigurations() {
        setImage(UIImage(systemName: "star"), for: .normal)
        setImage(UIImage(systemName: "star.fill"), for: .selected)
        imageView?.tintColor = .systemYellow
        contentMode = .scaleAspectFit
    }
}
