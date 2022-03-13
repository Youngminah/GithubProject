//
//  DefaultLabel.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UILabel

final class DefaultLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(text: String) {
        self.init()
        self.text = text
        self.font = .bodyDefaultRegular
        self.textColor = .gray600
    }

    convenience init(font: UIFont) {
        self.init()
        self.font = font
        self.textColor = .gray600
    }

    convenience init(text: String, font: UIFont) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = .gray600
    }

    convenience init(font: UIFont, textColor: UIColor) {
        self.init()
        self.font = font
        self.textColor = textColor
    }

    convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }

    required init?(coder: NSCoder) {
        fatalError("DefaultLabel: fatal Error Message")
    }

    private func setConfiguration() {
        self.numberOfLines = 0
        self.textAlignment = .left
    }
}
