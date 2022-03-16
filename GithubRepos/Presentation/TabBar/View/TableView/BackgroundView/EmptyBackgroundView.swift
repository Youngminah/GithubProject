//
//  EmptyTableBackgroundView.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit

final class EmptyBackgroundView: UIView {

    private let emptyImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    private let titleLabel = DefaultLabel(font: .headerMediumBold, textColor: .gray500)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, title: String, imageName: String) {
        self.init(frame: frame)
        titleLabel.text = title
        emptyImageView.image = UIImage(systemName: imageName)
    }

    convenience init(title: String, imageName: String) {
        self.init()
        titleLabel.text = title
        emptyImageView.image = UIImage(systemName: imageName)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConfigurations()
    }

    required init(coder: NSCoder) {
        fatalError("EmptyTableBackgroundView: fatal error")
    }

    private func setConfigurations() {
        addSubview(titleLabel)
        addSubview(emptyImageView)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(56)
            make.bottom.equalTo(titleLabel.snp.top).offset(-36)
        }
        emptyImageView.tintColor = .gray500
        titleLabel.textAlignment = .center
    }
}
