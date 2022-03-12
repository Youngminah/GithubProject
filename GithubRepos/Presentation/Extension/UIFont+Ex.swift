//
//  UIFont+Ex.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import UIKit.UIFont

extension UIFont {

    static var headerMediumBold: UIFont {
        return UIFont(name: AppFont.medium.rawValue, size: 24)!
    }
    static var subHeaderDefaultBold: UIFont {
        return UIFont(name: AppFont.bold.rawValue, size: 16)!
    }
    static var bodyTinyRegular: UIFont {
        return UIFont(name: AppFont.light.rawValue, size: 12)!
    }
    static var bodySmallRegular: UIFont {
        return UIFont(name: AppFont.regular.rawValue, size: 14)!
    }
    static var bodyDefaultRegular: UIFont {
        return UIFont(name: AppFont.regular.rawValue, size: 15)!
    }
    static var bodySmallMedium: UIFont {
        return UIFont(name: AppFont.medium.rawValue, size: 14)!
    }
    static var bodyDefaultMedium: UIFont {
        return UIFont(name: AppFont.medium.rawValue, size: 15)!
    }
    static var labelSmallBold: UIFont {
        return UIFont(name: AppFont.bold.rawValue, size: 11)!
    }
}

