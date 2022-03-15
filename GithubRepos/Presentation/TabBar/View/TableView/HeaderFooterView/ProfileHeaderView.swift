//
//  ProfileHeaderView.swift
//  GithubRepos
//
//  Created by meng on 2022/03/14.
//

import UIKit
import SnapKit

final class ProfileHeaderView: UITableViewHeaderFooterView {

    static let identifier = "ProfileHeaderView"
    //static let height: CGFloat = 200

    private let profileImageView = UIImageView()
    private let idLabel = DefaultLabel(font: .subHeaderDefaultBold, textColor: .gray500)
    private let nameLabel = DefaultLabel(font: .bodyDefaultMedium, textColor: .gray500)
    private let companyLabel = DefaultLabel(font: .bodySmallRegular, textColor: .gray500)
    private let locationLabel = DefaultLabel(font: .bodySmallRegular, textColor: .gray500)
    private let followerLabel = DefaultLabel(font: .bodySmallMedium, textColor: .gray500)
    private let followingLabel = DefaultLabel(font: .bodySmallMedium, textColor: .gray500)
    private let followerCountLabel = DefaultLabel(font: .bodySmallRegular, textColor: .gray500)
    private let followingCountLabel = DefaultLabel(font: .bodySmallRegular, textColor: .gray500)


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
        setConstraints()
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        fatalError("ProfileHeaderView: fatal error")
    }

    private func setView() {
        addSubview(profileImageView)
        addSubview(idLabel)
        addSubview(nameLabel)
        addSubview(companyLabel)
        addSubview(locationLabel)
        addSubview(followerLabel)
        addSubview(followerCountLabel)
        addSubview(followingLabel)
        addSubview(followingCountLabel)
    }

    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(5)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        followerLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(locationLabel)
        }
        followerCountLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(followerLabel.snp.right).offset(5)
            make.width.equalTo(40)
        }
        followingLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(followerCountLabel.snp.right).offset(16)
        }
        followingCountLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(followingLabel.snp.right).offset(5)
            make.width.equalTo(40)
        }
    }

    private func setConfigurations() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 50
    }

    func configure(user info: UserInfo) {
        followerLabel.text = "팔로워"
        followingLabel.text = "팔로잉"
        idLabel.text = info.userId
        nameLabel.text = info.name
        companyLabel.text = info.company
        locationLabel.text = info.location
        followerCountLabel.text = info.followers.toCommaString
        followingCountLabel.text = info.following.toCommaString
        guard let imageUrlString = info.avatarUrl else { return }
        profileImageView.setImageUrl(imageUrlString)
    }
}

