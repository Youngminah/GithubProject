//
//  ColorCircleView.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit

final class CircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("CircleView: fatal Error Message")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.bounds.width / 2
    }

    private func setConfiguration() {
        self.backgroundColor = .gray500
        self.layer.masksToBounds = true
    }

    func setColor(language: LanguageCase) {
        backgroundColor = language.color
    }
}
