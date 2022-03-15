//
//  ImageCacheManager.swift
//  GithubRepos
//
//  Created by meng on 2022/03/15.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
