//
//  TopicCell.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit
import SnapKit

final class TopicCell: BaseCollectionViewCell {

    static let identifier = "TopicCell"

    private let topicLabel = PaddingLabel(font: .bodySmallMedium, textColor: .blue400)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setView() {
        super.setView()
        contentView.addSubview(topicLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        topicLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalToSuperview().priority(.medium)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        topicLabel.backgroundColor = .blue100
        topicLabel.layer.masksToBounds = true
        topicLabel.layer.cornerRadius = 10
    }

    func configure(topic text: String) {
        topicLabel.text = text
    }
}
