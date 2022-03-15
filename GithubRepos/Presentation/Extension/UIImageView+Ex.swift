//
//  UIImageView.swift
//  GithubRepos
//
//  Created by meng on 2022/03/15.
//

import UIKit

extension UIImageView {

    func setImageUrl(_ url: String) {
        let cachedKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, result, error) in
            guard error == nil else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(systemName: "person.fill")
                }
                return
            }

            DispatchQueue.main.async { [weak self] in
                if let data = data, let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                    self?.image = image
                }
            }
        }.resume()
    }
}
