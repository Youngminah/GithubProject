//
//  PaddingLabel.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit.UILabel

final class PaddingLabel: UILabel {

    private var padding = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
    }

    convenience init(font: UIFont, textColor: UIColor) {
        self.init()
        self.font = font
        self.textColor = textColor
    }

    required init?(coder: NSCoder) {
        fatalError("PaddingLabel: fatal Error Message")
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
