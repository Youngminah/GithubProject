//
//  LoadingBackgroundView.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit

final class LoadingBackgroundView: UIView {

    private let imageView = UIImageView(image: UIImage(systemName: "hourglass"))
    private let titleLabel = DefaultLabel(font: .headerMediumBold, textColor: .gray500)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConfigurations()
    }

    required init(coder: NSCoder) {
        fatalError("LoadingBackgroundView: fatal error")
    }

    private func setConfigurations() {
        addSubview(titleLabel)
        addSubview(imageView)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(56)
            make.bottom.equalTo(titleLabel.snp.top).offset(-36)
        }
        imageView.tintColor = .gray500
        titleLabel.textAlignment = .center
        titleLabel.text = "검색중..."
        setAnimation()
    }

    private func setAnimation() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.toValue = Double.pi * 2
        rotation.duration = 3.0
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}

