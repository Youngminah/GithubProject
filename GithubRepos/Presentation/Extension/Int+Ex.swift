//
//  Int+Ex.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import Foundation

extension Int {

    var toCommaString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value:self))!
        return result
    }
}
